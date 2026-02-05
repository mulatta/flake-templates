{
  perSystem =
    {
      pkgs,
      python,
      workspace,
      editablePythonSet,
      ...
    }:
    let
      virtualenv = editablePythonSet.mkVirtualEnv "PROJ_NAME-dev" workspace.deps.all;
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          virtualenv
          pkgs.uv
        ];

        env = {
          UV_NO_SYNC = "1";
          UV_PYTHON = python.interpreter;
          UV_PYTHON_DOWNLOADS = "never";
        };

        shellHook = ''
          unset PYTHONPATH
          export REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
          export VIRTUAL_ENV="${virtualenv}"
        '';
      };
    };
}
