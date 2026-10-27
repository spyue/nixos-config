{
    description = "spyue nixos config";

    inputs = {
        #nixos version 
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

        #Home manager version 
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Older package set (delete when quarto is patched for pandoc)
        nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
      };

      outputs = {nixpkgs, home-manager, nixpkgs-2505, ... }: 
        let 
          pkgs-2505 = import nixpkgs-2505 {system = "x86_64-linux";};

          #This builds a machine from its folder in ./hosts
          mkHost = hostDir: nixpkgs.lib.nixosSystem {
              specialArgs = {inherit pkgs-2505;};
              modules = [
                hostDir
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  #This makes existing dotfiles causing issues to be renamed *.backup instead of failing
                  home-manager.backupFileExtension = "backup";
                  home-manager.extraSpecialArgs = {inherit pkgs-2505;};
                }
              ];
          };
        in 
        {
          nixosConfigurations = {
              nixoslaptop = mkHost ./hosts/nixoslaptop;
              nixostower = mkHost ./hosts/nixostower;
            };
          };
  }
