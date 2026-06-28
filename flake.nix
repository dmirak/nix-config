{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, niri, noctalia, ... }: {
    nixosConfigurations.nixos-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
	niri.nixosModules.niri
        home-manager.nixosModules.home-manager 
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
	    extraSpecialArgs = { inherit inputs; };
            users.david = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
