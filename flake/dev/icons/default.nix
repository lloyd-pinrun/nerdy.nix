{
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    inherit (pkgs) python3 writers;

    nerdy = writers.writePython3Bin "nerdy" {
      flakeIgnore = ["E501"];
      libraries = with python3.pkgs; [rtoml];
    } (builtins.readFile ./generate.py);
  in {
    devenv.shells.default = {
      tasks = {
        "nerdy:icons:generate" = {
          exec = "${lib.getExe nerdy} --output $PWD/generated";
          package = nerdy;
        };

        "nerdy:icons:clean".exec = ''
          echo "Cleaning existing icons..."
          rm -r $PWD/generated
        '';
      };
    };
  };
}
