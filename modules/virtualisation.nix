{self, ...}: {
  flake.modules.nixos = {
    # The de-facto for virtual machines. It's very fast and reliable and all
    # If you have experience with VirtualBox, VMware Workstation, or Parallels Desktop, this is what you're looking for on Linux and NixOS
    # For the best performance ensure that your host UEFI settings have Vt-x and Vt-d (Intel) or AMD-V and AMD-Vi (AMD) enabled
    virt-manager = {pkgs, ...}: {
      users = {
        groups.libvirtd.members = [self.username];
        users.${self.username}.extraGroups = ["libvirtd"];
      };

      # Required for DNS and DCHP functionality within the default libvirt network
      environment.systemPackages = [pkgs.dnsmasq];

      # Allow the virtual network bridge through the firewall
      networking.firewall.trustedInterfaces = ["virbr0"];

      # Virt-manager
      programs.virt-manager.enable = true;
      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
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

    # I Recommended avoiding this because it requires compiling from source
    # This is due to some licensing issues
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