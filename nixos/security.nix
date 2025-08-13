{pkgs, ...}: {
  security = {
    polkit.enable = true;

    rtkit.enable = true;

    sudo.extraRules = [
      {
        users = ["cameron"];
        commands = [
          {
            command = "/run/current-system/sw/bin/dmidecode";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
