{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.partitions

    ./flake-modules
  ];

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
