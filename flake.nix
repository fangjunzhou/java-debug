{
  description = "Java Debug Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib;
    eachSystem [
      system.x86_64-linux
      system.x86_64-darwin
    ]
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          packages.default = pkgs.maven.buildMavenPackage {
            pname = "vscode-debug";
            version = "0.51.0";

            src = ./.;
            mvnHash = "sha256-Fx1EVnWRjRGBvVN7RfYCx+tBuPgG1gte3w8oVJkAkj8=";

            buildPhase = ''
              mvn clean package
            '';

            installPhase = ''
              cp -r . $out
            '';
          };
        }
      );
}
