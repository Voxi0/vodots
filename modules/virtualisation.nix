{self, ...}: {
  flake.modules.nixos = {
    # The de-facto for virtual machines. It's very fast and reliable and all
    # If you have experience with VirtualBox, VMware Workstation, or Parallels Desktop, this is what you're looking for on Linux and NixOS
    # For the best performance ensure that your host UEFI settings have Vt-x and Vt-d (Intel) or AMD-V and AMD-Vi (AMD) enabled
    virt-manager = {
      users = {
        groups.libvirtd.members = [self.username];
        users.${self.username}.extraGroups = ["libvirtd"];
      };
      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
      programs.virt-manager = {
        enable = true;
      };

      # Create a virtualisation connection for virt-manager
      # Can be done imperatively but why not declaratively?
      home-manager.users.${self.username} = {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };
      };
    };

    # Recommended to avoid because it requires compiling from source
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
