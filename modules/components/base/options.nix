{
  flake.modules.homeManager.base = { lib, ... }: {
    options = {
      isLaptop = lib.mkEnableOption "is this laptop?";
    };
  };
}
