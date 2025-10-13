_localFlake: {lib, ...}: let
  inherit
    (lib)
    importTOML
    mkOption
    types
    ;
in {
  options.lib.nerdy = mkOption {
    type = types.attrsOf types.attrs;
    readOnly = true;
    default = importTOML ./assets/glyphs.toml;
  };
}
