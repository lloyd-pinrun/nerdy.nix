{
  description = "A nixos flake to provide mnuemonic access to nerd-font glyphs";

  inputs = {
    # -- Essential --
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nerd-glyphs.url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json";
    nerd-glyphs.flake = false;

    search.url = "github:nuschtos/search";
    search.inputs.nixpkgs.follows = "nixpkgs";

    # -- Development --
    just.url = "github:lloyd-pinrun/just.nix";
    just.inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
      pre-commit.follows = "pre-commit";
    };
    pre-commit.url = "github:cachix/git-hooks.nix";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./default.nix];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
