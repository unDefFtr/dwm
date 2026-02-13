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

          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.autoPatchelfHook
            pkgs.patchelf
          ];
          buildInputs = [
            pkgs.xorg.libX11.dev
            pkgs.xorg.libXinerama.dev
            pkgs.xorg.libXft.dev
            pkgs.xorg.libXrender.dev
            pkgs.xorg.xorgproto
            pkgs.fontconfig.dev
            pkgs.freetype.dev
            pkgs.xorg.libX11
            pkgs.xorg.libXinerama
            pkgs.xorg.libXft
            pkgs.xorg.libXrender
            pkgs.fontconfig
            pkgs.freetype
          ];

          makeFlags = [
            "PREFIX=$(out)"
            "CFLAGS=$NIX_CFLAGS_COMPILE"
            "LDFLAGS=$NIX_LDFLAGS"
          ];
          installTargets = [ "install" ];
          postInstall = ''
            install -Dm644 ${./dwm.desktop} $out/share/xsessions/dwm.desktop
          '';

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
            pkgs.libx11
            pkgs.libxinerama
            pkgs.libxft
            pkgs.libxrender
            pkgs.fontconfig
            pkgs.pkg-config
            pkgs.patchelf
          ];
        };
      }
    );
}
