{
  inputs = {
    root.url = "path:../../";

    flake-parts.follows = "root/flake-parts";
    nixpkgs.follows = "root/nixpkgs";

    # -- Development --
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = _inputs: {};
}
