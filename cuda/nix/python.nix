{
  inputs,
  workspaceRoot,
}:
let
  inherit (inputs.nixpkgs) lib;

  workspace = inputs.uv2nix.lib.workspace.loadWorkspace { inherit workspaceRoot; };

  pythonOverlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

  isCudaWheel =
    name:
    lib.hasPrefix "nvidia-" name
    || builtins.elem name [
      "torch"
      "triton"
    ];

  cudaWheelOverrides =
    _final: prev:
    lib.mapAttrs (
      _name: package:
      package.overrideAttrs {
        # CUDA wheels resolve libraries supplied by sibling wheels at runtime.
        autoPatchelfIgnoreMissingDeps = true;
      }
    ) (lib.filterAttrs (name: _package: isCudaWheel name) prev);
in
{
  inherit workspace;

  mkPythonSet =
    pkgs:
    let
      overlays = [
        inputs.pyproject-build-systems.overlays.wheel
        pythonOverlay
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        cudaWheelOverrides
      ];
    in
    (pkgs.callPackage inputs.pyproject-nix.build.packages {
      python = pkgs.python3;
    }).overrideScope
      (lib.composeManyExtensions overlays);
}
