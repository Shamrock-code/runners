{ pkgs ? import <nixpkgs> {} }:

let
in
pkgs.mkShell {

  buildInputs = [
    pkgs.jq
    pkgs.curl
  ];
}