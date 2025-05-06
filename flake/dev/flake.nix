{
  inputs = {
    root.url = "path:../../";

    flake-parts.follows = "root/flake-parts";
    nixpkgs.follows = "root/nixpkgs";

    # -- Development --
    just.url = "github:lloyd-pinrun/just.nix";
    just.inputs = {
      flake-parts.follows = "flake-parts";
      nixpkgs.follows = "nixpkgs";
      pre-commit.follows = "pre-commit";
    };

    pre-commit.url = "github:cachix/git-hooks.nix";
    pre-commit.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = _inputs: {};
}
