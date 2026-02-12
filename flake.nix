{
  description = "dwm - dynamic window manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.dwm = pkgs.stdenv.mkDerivation {
          pname = "dwm";
          version = "local";
          src = self;

          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [
            pkgs.xorg.libX11
            pkgs.xorg.libXinerama
            pkgs.xorg.libXft
          ];

          makeFlags = [ "PREFIX=$(out)" ];
          installTargets = [ "install" ];

          meta = with pkgs.lib; {
            description = "dynamic window manager";
            homepage = "https://dwm.suckless.org/";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };

        packages.default = self.packages.${system}.dwm;

        apps.dwm = flake-utils.lib.mkApp {
          drv = self.packages.${system}.dwm;
          exePath = "/bin/dwm";
        };
        apps.default = self.apps.${system}.dwm;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.xorg.libX11
            pkgs.xorg.libXinerama
            pkgs.xorg.libXft
            pkgs.pkg-config
          ];
        };
      }
    );
}
