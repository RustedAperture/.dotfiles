{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    plasmazones = {
      url = "github:fuddlesworth/PlasmaZones";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    plasma-manager,
    ...
  }: let
    system = "x86_64-linux";
  in {
    overlays.default = final: prev: {
      t3code-nightly = final.callPackage ./pkgs/t3code-nightly {};
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        inputs.plasmazones.nixosModules.default

        {nixpkgs.overlays = [self.overlays.default];}

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
            plasma-manager.homeModules.plasma-manager
          ];
        }

        ./nixos/configuration.nix
      ];

      specialArgs = {
        inherit inputs;
      };
    };

    homeConfigurations.cameron = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      };
      modules = [
        ./home-manager/home.nix
      ];
    };
  };
}
