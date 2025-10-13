{
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    inherit (builtins) readFile;
    inherit (lib) getExe;

    inherit
      (pkgs)
      python3
      writers
      ;

    package = writers.writePython3Bin "update-glyphs" {
      flakeIgnore = ["E501"];
      libraries = with python3.pkgs; [rtoml];
    } (readFile ./update-glyphs.py);
  in {
    devenv.shells.default.tasks."nerdy:update-glyphs" = {
      exec = "${getExe package}";
    };
  };
}
