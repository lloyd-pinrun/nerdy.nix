{
  perSystem = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (config) nerdy;

    inherit
      (lib)
      mkEnableOption
      mkOption
      types
      ;

    inherit (pkgs) mkShell;

    inherit (pkgs.python3Packages) buildPythonApplication;
  in {
    options.nerdy = {
      enable = mkEnableOption "nerdy" // {default = true;};
      update = mkOption {
        type = types.package;
        readOnly = true;
      };

      devShell = mkOption {
        type = types.package;
        readOnly = true;
        description = "Nerdy development shell";
      };
    };

    config = {
      nerdy = {
        enable = true;
        update = buildPythonApplication {
          pname = "nerdy-update";
          version = "0.0.1";
          pyproject = false;
          src = ./update.py;
          format = "other";

          propagatedBuildInputs = with pkgs.python3Packages; [
            rtoml
          ];

          installPhase = ''
            mkdir =p $out/bin
            cp update.py $out/bin/nerdy-update
            chmod +x $out/bin/nerd-update
          '';
        };

        devShell = mkShell {
          packages = [nerdy.update];
        };
      };

      just.recipes."nerdy *ARGS" = "nix run .#nerdy.$(nix eval --raw --impure --expr \"builtins.currentSystem\").update \"\#{NIX_OPTIONS[@]}\" -- {{ ARGS }}";
    };
  };
}
