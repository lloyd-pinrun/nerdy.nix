{
  flake-parts-lib,
  inputs,
  self,
  ...
}: let
  inherit (flake-parts-lib) importApply;

  nerdy = importApply ./wrapper.nix self;

  defaultModules = {
    darwinModules = {
      inherit nerdy;
      default = self.darwinModules.nerdy;
    };
    homeModules = {
      inherit nerdy;
      default = self.homeModules.nerdy;
    };
    nixosModules = {
      inherit nerdy;
      default = self.nixosModules.nerdy;
    };
  };

  extraModules = {
    default.imports = builtins.attrValues defaultModules;
  };
in {
  imports = [inputs.flake-parts.flakeModules.flakeModules];

  flake.flakeModules = defaultModules // extraModules;
}
