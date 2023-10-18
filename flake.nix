{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = inputs@{ self, flake-parts,  ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
      ];


      perSystem = { config, self', inputs', pkgs, system, ... }:
      let
	      nixpkgs-channel = "nixos-stable";
       in
        rec
        {

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;

		config = {
	    		allowUnfree = true;

		};
          };

          devShells = {
            development = pkgs.mkShell {
		buildInputs = with pkgs; [
    		   tuckr
		];
            };

          };
         devShells.default = devShells.development;

        };

    };
}
