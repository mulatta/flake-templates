{
  description = "Personal development templates";

  outputs =
    { ... }:
    {
      templates = {
        default = {
          path = ./default;
          description = "Basic flake-parts template with treefmt-nix";
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
