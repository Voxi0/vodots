{self, ...}: {
  flake.modules.nixos = {
    # A daemon that manages virtual machines
    libvirtd = {
      virtualisation.libvirtd.enable = true;
      users.users.${self.username}.extraGroups = [ "libvirtd" ];
    };

    # GUI application for managing local and remote virtual machines through libvirt
    # Having Vt-x and Vt-d (Intel) or AMD-V and AMD-Vi (AMD) enabled ensures the best performance
    # These settings can usually be found in the BIOS/UEFI
    virt-manager = {pkgs, ...}: {
      imports = [self.modules.nixos.libvirtd];
      programs.virt-manager.enable = true;

      # Allow the default virtual network bridge "virbr0" through the firewall
      networking.firewall.trustedInterfaces = [ "virbr0" ];

      # Required to use the default libvirt network
      # This is required for DNS and DCHP functionality within the network
      environment.systemPackages = [pkgs.dnsmasq];
    };
  };
}
