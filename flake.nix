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

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    sops-nix,
    plasma-manager,
    nixpkgs-xr,
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

          nixpkgs.overlays = [
            (import ./nixos/overlays/kernel-hdmi-frl-vrr.nix)
          ];
        }

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cameron = import ./home-manager/home.nix;

          home-manager.sharedModules = [
            sops-nix.homeManagerModules.sops
            plasma-manager.homeManagerModules.plasma-manager
          ];
        }

        ./nixos/configuration.nix

        nixpkgs-xr.nixosModules.nixpkgs-xr
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
