#!/usr/bin/env bash
flameshot gui -r > /tmp/screenshot.png
# Read token from file provided via home manager (managed by sops-nix)
AUTH_HEADER="authorization: $(cat /home/cameron/.config/zipline/token)"
curl -H "$AUTH_HEADER" https://s.camv.xyz/api/upload -F file=@/tmp/screenshot.png -H 'content-type: multipart/form-data' -H 'x-zipline-format: uuid' | jq -r .files[0].url | tr -d '\n' | wl-copy
