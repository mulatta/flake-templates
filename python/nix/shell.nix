{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          python3
          ruff
        ];

        shellHook = ''
          if [ ! -d .venv ]; then
            python -m venv .venv
          fi
          source .venv/bin/activate
        '';
      };
    };
}
