{self, ...}: {
  flake.modules.nixos = {
    virtualbox = {
      users.extraGroups.vboxusers.members = [self.username];
      virtualisation.virtualbox = {
        host = {
          enable = true;
          enableExtensionPack = true;
        };
      };
    };
  };
}
