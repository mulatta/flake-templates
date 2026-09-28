{ pkgs }:
let
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = [
      "rust-src"
      "rust-analyzer"
      "clippy"
      "rustfmt"
    ];
  };
in
{
  default = pkgs.mkShell {
    packages = [ rustToolchain ];
  };
}
