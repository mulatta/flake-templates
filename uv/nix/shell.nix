{ pkgs }:
{
  default = pkgs.mkShell {
    packages = with pkgs; [
      python3
      uv
    ];

    env = {
      UV_PYTHON_DOWNLOADS = "never";
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ];
    };

    shellHook = ''
      if ! root=$(git rev-parse --show-toplevel 2>/dev/null); then
        echo "warning: not in a git repo, using PWD" >&2
        root=$PWD
      fi
      uv sync --frozen --quiet
      source "$root/.venv/bin/activate"
    '';
  };
}
