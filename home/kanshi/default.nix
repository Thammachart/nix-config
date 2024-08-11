{pkgs, ...}:
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        output.scale = 1.5;
      }
    ];
  };
}
