{
  description = "Personal development templates";

  outputs =
    { ... }:
    {
      templates = {
        base = {
          path = ./base;
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
      };
    };
}
