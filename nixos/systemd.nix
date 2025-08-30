{
  config,
  pkgs,
  ...
}: let
  monitorsXmlContent = builtins.readFile ./monitors.xml;
  monitorsConfig = pkgs.writeText "gdm_monitors.xml" monitorsXmlContent;
in {
  systemd = {
    tmpfiles.rules = [
      "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
    ];

    services.iwd-wifi-setup = {
      description = "Setup WiFi connection with iwd";
      wantedBy = ["multi-user.target"];
      after = ["iwd.service"];
      wants = ["iwd.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        StandardOutput = "journal";
        StandardError = "journal";
      };
      script = ''
        set -e

        echo "Starting WiFi setup service..."

        # Check if sops secrets exist
        if [ ! -f "${config.sops.secrets."wifi/ssid".path}" ]; then
          echo "ERROR: WiFi SSID secret not found at ${config.sops.secrets."wifi/ssid".path}"
          exit 1
        fi

        if [ ! -f "${config.sops.secrets."wifi/passphrase".path}" ]; then
          echo "ERROR: WiFi passphrase secret not found at ${config.sops.secrets."wifi/passphrase".path}"
          exit 1
        fi

        echo "Secrets found, waiting for iwd..."

        # Wait for iwd to be ready with timeout
        TIMEOUT=60
        COUNT=0
        while [ $COUNT -lt $TIMEOUT ]; do
          if ${pkgs.iwd}/bin/iwctl device list > /dev/null 2>&1; then
            echo "iwd is ready"
            break
          fi
          echo "Waiting for iwd... ($COUNT/$TIMEOUT)"
          sleep 2
          COUNT=$((COUNT + 2))
        done

        if [ $COUNT -ge $TIMEOUT ]; then
          echo "ERROR: Timeout waiting for iwd to be ready"
          exit 1
        fi

        # Find the actual WiFi device - look for devices in station mode
        echo "Looking for WiFi devices..."
        ${pkgs.iwd}/bin/iwctl device list

        DEVICE="wlan0"

        # Verify the device exists and is in station mode
        if ! ${pkgs.iwd}/bin/iwctl device list | grep -q "wlan0.*station"; then
          echo "ERROR: wlan0 device not found or not in station mode"
          echo "Available devices:"
          ${pkgs.iwd}/bin/iwctl device list
          exit 1
        fi

        echo "Using WiFi device: $DEVICE"

        SSID=$(cat ${config.sops.secrets."wifi/ssid".path} | tr -d '\n\r' | sed 's/[[:space:]]*$//')
        PASSPHRASE=$(cat ${config.sops.secrets."wifi/passphrase".path} | tr -d '\n\r' | sed 's/[[:space:]]*$//')

        echo "Connecting to SSID: '$SSID'"
        echo "SSID length: ''${#SSID}"

        # Check if already connected
        if ${pkgs.iwd}/bin/iwctl station "$DEVICE" show | grep -q "Connected network.*$SSID"; then
          echo "Already connected to $SSID"
          exit 0
        fi

        # Connect to WiFi
        echo "Attempting to connect..."
        if ${pkgs.iwd}/bin/iwctl --passphrase "$PASSPHRASE" station "$DEVICE" connect "$SSID"; then
          echo "Successfully connected to $SSID"
        else
          echo "ERROR: Failed to connect to $SSID"
          exit 1
        fi
      '';
    };
  };
}
