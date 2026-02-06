{
  description = "St Andrews Computer Science Checker (stacscheck)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        stacscheck = pkgs.writers.writePython3Bin "stacscheck" {
          libraries = with pkgs.python3Packages; [ jinja2 ];
          doCheck = false;
        } (builtins.readFile ./stacscheck);
      in
      {
        packages.default = stacscheck;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages (ps: with ps; [ jinja2 ]))
            pkgs.bashInteractive
            stacscheck
          ];
        };
      }
    );
}
