{
  description = "A nixos flake to provide mnuemonic access to nerd-font glyphs";

  inputs = {
    # -- Essential --
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    nerd-glyphs.url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/glyphnames.json";
    nerd-glyphs.flake = false;
  };

  outputs = inputs @ {flake-parts, ...}: let
    systems = import inputs.systems;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      inherit systems;

      imports = [./flake];
    };
}
