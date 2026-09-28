{
  pkgs,
  pythonSet,
  workspace,
}:
let
  inherit (pkgs) lib;

  editablePythonSet = pythonSet.overrideScope (
    workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; }
  );
  virtualenv = editablePythonSet.mkVirtualEnv "PROJ_NAME-dev" workspace.deps.all;

  base = {
    packages = [
      pkgs.git
      pkgs.uv
    ];
    env = {
      UV_PYTHON = pythonSet.python.interpreter;
      UV_PYTHON_DOWNLOADS = "never";
    };
    shellHook = ''
      unset PYTHONPATH
      export REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
    '';
  };

  mkDevShell =
    args:
    pkgs.mkShell (
      base
      // args
      // {
        packages = (args.packages or [ ]) ++ base.packages;
        env = base.env // (args.env or { });
        shellHook = base.shellHook + (args.shellHook or "");
      }
    );

  driverPackages = lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.addDriverRunpath.driverLink;
in
{
  default = mkDevShell {
    packages = [ virtualenv ];
    env = {
      UV_NO_SYNC = "1";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      LD_LIBRARY_PATH = lib.makeLibraryPath driverPackages;
    };
  };

  impure = mkDevShell {
    packages = [ pythonSet.python ];
    env = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      LD_LIBRARY_PATH = lib.makeLibraryPath (
        [
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
        ]
        ++ driverPackages
      );
    };
    shellHook = ''
      if [ ! -x .venv/bin/python ] || [ uv.lock -nt .venv/pyvenv.cfg ]; then
        uv sync --frozen
      fi
      . .venv/bin/activate
    '';
  };
}
