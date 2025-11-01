{
  flake.modules.nixos.hosts_tiikeri-pivot = { configData, ... }: {
    users.users."${configData.username}".extraGroups = [ "docker" "kvm" ];
  };
}
