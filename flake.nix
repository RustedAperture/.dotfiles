{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    chaotic,
    home-manager,
    sops-nix,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops

        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        }

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cameron = import ./home-manager/home.nix;

          home-manager.sharedModules = [
            sops-nix.homeManagerModules.sops
          ];
        }

        ./nixos/configuration.nix
        chaotic.nixosModules.default
      ];

      specialArgs = {
        inherit inputs;
      };
    };

    homeConfigurations.cameron = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./home-manager/home.nix
      ];
    };
  };
}
