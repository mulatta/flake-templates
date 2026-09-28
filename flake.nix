{
  description = "Personal development templates";

  outputs =
    { ... }:
    {
      templates = {
        default = {
          path = ./default;
          description = "Lightweight flake with treefmt-nix";
        };
        python = {
          path = ./python;
          description = "Python project with venv and ruff";
        };
        rust = {
          path = ./rust;
          description = "Rust project with rust-overlay";
        };
        uv = {
          path = ./uv;
          description = "Python project with uv package manager";
        };
        uv2nix = {
          path = ./uv2nix;
          description = "Reproducible Python project with uv2nix";
        };
        cuda = {
          path = ./cuda;
          description = "Python ML project with uv2nix and CUDA wheel support";
        };
        nix-shell = {
          path = ./nix-shell;
          description = "Non-flake nix-shell with direnv";
        };
        pixi = {
          path = ./pixi;
          description = "Scientific projet with pixi for complex dependnecies";
        };
      };
    };
}
