{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "fhs-dev-env";
  
  # 这里的 targetPkgs 是在 FHS 环境中 /usr 等目录下可见的包
  targetPkgs = pkgs: with pkgs; [
    gcc
    gnumake
    binutils
    gdb
    pkg-config
    # 在这里添加你需要的其他依赖，比如 zlib, glibc 等
    xorg.libX11.dev
    xorg.libXinerama.dev
    xorg.libXft.dev
    xorg.libXrender.dev
    xorg.xorgproto
    fontconfig.dev
    freetype.dev

    xorg.libX11
    xorg.libXinerama
    xorg.libXft
    xorg.libXrender
    fontconfig
    freetype
  ];

  # 如果你需要运行某些需要特定环境变量的程序，可以在 runScript 里定义
  runScript = "bash";
}).env
