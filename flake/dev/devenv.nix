{inputs, ...}: {
  imports = [inputs.devenv.flakeModule];

  perSystem = {
    config,
    pkgs,
    ...
  }: let
    treefmt = config.treefmt.build.wrapper;
  in {
    devenv.shells.default = {
      packages = with pkgs; [
        nix-inspect
        treefmt
      ];

      git-hooks = {
        hooks = {
          # -- pre-commit builtins --
          # keep-sorted start block=yes newline_separated=no
          check-added-large-files.enable = true;
          check-builtin-literals.enable = true;
          check-case-conflicts.enable = true;
          check-docstring-first.enable = true;
          check-executables-have-shebangs.enable = true;
          check-merge-conflicts.enable = true;
          check-python.enable = true;
          check-symlinks.enable = true;
          check-vcs-permalinks.enable = true;
          end-of-file-fixer.enable = true;
          fix-byte-order-marker.enable = true;
          forbid-new-submodules.enable = true;
          mixed-line-endings.enable = true;
          name-tests-test.enable = true;
          no-commit-to-branch = {
            enable = false;
            settings.branch = ["main"];
          };
          python-debug-statements.enable = true;
          trim-trailing-whitespace.enable = true;
          # keep-sorted end

          # -- third-party --
          # keep-sorted start block=yes newline_separated=no
          tagref.enable = true;
          treefmt = {
            enable = true;
            package = treefmt;
            settings.formatters = with pkgs; [
              alejandra
              deadnix
              keep-sorted
              nixf-diagnose
              ruff
              statix
            ];
          };
          typos.enable = true;
          # keep-sorted end

          # -- nix --
          # keep-sorted start
          flake-checker.enable = true;
          # keep-sorted end

          # -- langs --
          markdownlint = {
            enable = true;
            settings.configuration = {
              MD033.allowed_elements = ["h1" "code"];
              MD013.line_length = 128;
            };
          };
        };
      };
    };
  };
}
