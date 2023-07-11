{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  shellHook = ''
    export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig
  '';
  buildInputs = with pkgs; [
    crystal
    lucky-cli
    overmind
    nodejs
    openssl.dev
    postgresql
    shards
    yarn
  ];
}
