{
  flake-parts-lib,
  inputs,
  self,
  ...
}: let
  inherit (flake-parts-lib) importApply;
in {
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.flake-parts.flakeModules.partitions
  ];

  flake = {
    darwinModules = {
      nerdy = importApply ./wrapper.nix self;
      default = self.darwinModules.nerdy;
    };

    homeModules = {
      nerdy = importApply ./wrapper.nix self;
      default = self.darwinModules.nerdy;
    };

    nixosModules = {
      nerdy = importApply ./wrapper.nix self;
      default = self.nixosModules.nerdy;
    };
  };

  partitions.dev = {
    module = ./dev;
    extraInputsFlake = ./dev;
  };

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
  };
}
