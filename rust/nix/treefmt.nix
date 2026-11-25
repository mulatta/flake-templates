{
  projectRootFile = "flake.nix";
  programs = {
    deadnix.enable = true;
    nixfmt.enable = true;
    rustfmt.enable = true;
    shellcheck.enable = true;
    statix.enable = true;
  };
}
