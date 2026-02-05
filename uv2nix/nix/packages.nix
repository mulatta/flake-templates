{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      workspace = inputs.uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./..; };

      overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

      editableOverlay = workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };

      python = pkgs.python312;

      baseSet = pkgs.callPackage inputs.pyproject-nix.build.packages { inherit python; };

      pythonSet = baseSet.overrideScope (
        lib.composeManyExtensions [
          inputs.pyproject-build-systems.overlays.wheel
          overlay
        ]
      );

      editablePythonSet = pythonSet.overrideScope editableOverlay;
    in
    {
      _module.args = {
        inherit
          workspace
          pythonSet
          editablePythonSet
          python
          ;
      };

      packages = {
        default = pythonSet.mkVirtualEnv "PROJ_NAME-env" workspace.deps.default;
        full = pythonSet.mkVirtualEnv "PROJ_NAME-full-env" workspace.deps.all;
      };
    };
}
