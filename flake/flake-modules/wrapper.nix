_localFlake: {lib, ...}: let
  inherit (lib) types;

  imported = let
    iconsDir = ./generated;
    onlyTomlFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".toml" name) (builtins.readDir iconsDir);
  in
    lib.mapAttrs' (
      name: _:
        lib.nameValuePair
        (lib.removeSuffix ".toml" name)
        (lib.importToml (iconsDir + "/${name}"))
    )
    onlyTomlFiles;
in {
  options.lib.nerdy = lib.mkOption {
    type = types.attrsOf types.attrs;
    readOnly = true;
    default = imported;
  };
}
