{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      systems = [
        "x86_64-linux"
      ];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        initDrv = pkgs.buildGoModule rec {
          pname = "init";
          version = "0.0.0";
          src = ./.;
          subpackages = "./subpackages";
          vendorHash = null;
        };
      in rec
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
        };

        overlayAttrs = {
          inherit (config.packages) init;
        };

        devShells = {
          development = pkgs.mkShell {
            buildInputs = with pkgs; [
              gopls
              go
              just
            ];
          };
        };
        devShells.default = devShells.development;

        packages = {
          init = initDrv;
        };
        packages.default = packages.init;

        formatter = pkgs.writeShellApplication {
          name = "treefmt";
          runtimeInputs = with pkgs; [
            treefmt
            go
            alejandra
          ];
          text = ''
            exec treefmt "$@"
          '';
        };
      };
    };
}
