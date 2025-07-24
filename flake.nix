{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs =
    { nixpkgs, ... }:
    {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
          }
          ./configuration.nix
        ];
      };

    };

}
