{inputs, ...}: {
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

    packageExe = getExe package;
  in {
    just.recipes."update *ARGS" = "${packageExe} ${inputs.nerd-glyphs} {{ ARGS }}";
  };
}
