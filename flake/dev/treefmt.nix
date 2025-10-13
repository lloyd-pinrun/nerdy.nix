{inputs, ...}: {
  imports = [inputs.treefmt.flakeModule];

  perSystem = {config, ...}: {
    formatter = config.treefmt.build.wrapper;

    treefmt = {
      flakeCheck = true;
      flakeFormatter = true;

      projectRootFile = "README.md";

      programs = {
        # keep-sorted start block=yes newline_separated=no
        alejandra.enable = true;
        deadnix.enable = true;
        keep-sorted.enable = true;
        nixf-diagnose = {
          enable = true;
          priority = -1;
        };
        ruff-check = {
          enable = true;
          priority = 1;
        };
        ruff-format = {
          enable = true;
          priority = 2;
        };
        statix = {
          enable = true;
          priority = -2;
        };
        # keep-sorted end
      };

      settings = {
        global.excludes = [
          # keep-sorted start
          "*flake.lock"
          ".editorconfig"
          ".envrc"
          ".gitignore"
          # keep-sorted end
        ];

        # keep-sorted start block=yes newline_separated=no
        formatter.nixf-diagnose.options = [
          "--auto-fix"
          "--ignore=sema-unused-def-lambda-witharg-formal"
        ];
        # keep-sorted end
      };
    };
  };
}
