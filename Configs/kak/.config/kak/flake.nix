{
  description = "A flake configuration meant to be helpful in some way.";

  inputs = {
    # I know NixOS can be stable but we're going cutting edge, baybee! While
    # `nixpkgs-unstable` branch could be faster delivering updates, it is
    # looser when it comes to stability for the entirety of this configuration.
    nixpkgs.url = "github:NixOS/nixpkgs";

    # Here are the nixpkgs variants used for creating the dev shells.
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
      ];

      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];


      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          nixpkgs-channel = "nixos-unstable";
        in
        rec
        {
          _module = {
            args = {
              pkgs = import inputs."${nixpkgs-channel}" or inputs.nixpkgs {
                inherit system;
              };
            };
          };

          # Some packages for testing the config in another computer.
          # Note this doesn't install the files for you, this is meant only for trying it out.
          devShells = {
            development = pkgs.mkShell {
              buildInputs = with pkgs; [
                kakoune
              ];
            };

          };
          devShells.default = devShells.development;

        };

    };
}
