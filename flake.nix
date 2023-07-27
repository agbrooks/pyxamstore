{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    with nixpkgs.legacyPackages.${system}; {
      packages.default = python3Packages.buildPythonPackage {
        pname = "pyxamstore";
        version = "1.0.0";
        src = ./.;
        propagatedBuildInputs = with python3Packages; [ lz4 xxhash ];
        passthru.exePath = "/bin/pyxamstore";
      };

      devShells.default = with pkgs; mkShell {
        inputsFrom = [self.packages."${system}".default];
      };
    }
  );
}
