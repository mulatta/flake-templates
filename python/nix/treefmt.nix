{
  projectRootFile = "flake.nix";
  programs = {
    deadnix.enable = true;
    nixfmt.enable = true;
    ruff-check.enable = true;
    ruff-format.enable = true;
    statix.enable = true;
  };
}
