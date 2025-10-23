{
  description = "flake for beer-dataset dev environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }@inputs:
    let

      inherit (self) outputs;

      supportedSystems = [ "x86_64-linux" ];

      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
          (system: f { pkgs = import nixpkgs { inherit system; }; });

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in rec {

      # define development shell configuration
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            (python3.withPackages (ps: [ ] ))
            cachix
            aria2
            wget
          ];
          shellHook = ''
          echo -e "Initializing development environment..."
          set -e
          # load the defined functions
          source ./scripts/get-images.sh
          '';
        };
      });

  };
}
