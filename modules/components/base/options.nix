{
  flake.modules.nixos.base = { lib, ... }: {
    options = {
      conditions = {
        isLaptop = lib.mkEnableOption "Laptop?";
      };
    };
  };
}
