{
  perSystem =
    { pkgs, ... }:
    let
      pixiEnv = pkgs.buildFHSEnv {
        name = "pixi-env";
        targetPkgs = _: [ pkgs.pixi ];
        runScript = "bash";
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [ pixiEnv ];
        inputsFrom = [ pixiEnv.env ];
      };
    };
}
