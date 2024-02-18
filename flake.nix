{
  description = "AlGhoul's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { nixpkgs, home-manager, devenv, nixvim, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        AlGhoul = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };

          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alghoul = {
                imports = [
                  ./home.nix
                  nixvim.homeManagerModules.nixvim
                ];
              };
            }
          ];
        };
      };

      devShells.x86_64-linux.default = devenv.lib.mkShell {
        inherit inputs pkgs;

        modules = [
          ({ ... }: {

            packages = with pkgs; [
              yarn
              cz-cli # commitizen
            ];

            pre-commit.hooks = {
              deadnix.enable = true;
              nixpkgs-fmt.enable = true;
              nil.enable = true;
              commitizen.enable = true;
              markdownlint.enable = true;
            };

            scripts.pre.exec = ''
              .git/hooks/pre-commit
            '';

          })

        ];


      };

    };
}
