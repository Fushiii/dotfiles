{
  description = "Flake for setting up the system.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    zelda.url = "github:enmeei/zelda";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = { config, self', inputs', pkgs, system, ... }:
        let

        in
        rec
        {
          _module.args = {
            pkgs = import inputs.nixpkgs {
              # This makes the nixpkgs be the one
              # suited to your current development system;
              inherit system;

              overlays = with inputs; [
                zelda.overlays.default
              ];
            };
          };

          devShells = {
            development = pkgs.mkShell {
              buildInputs = with pkgs; [
                zelda
              ];
            };
          };
          devShells.default = devShells.development;

        };

    };
}

