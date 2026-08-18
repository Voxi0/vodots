{inputs, ...}: {
  # Import flake-parts modules
  imports = with inputs; [
    flake-parts.flakeModules.modules
    wrappers.flakeModules.wrappers
  ];

  # Global variables that the entire config can use
  flake = {
    # General
    username = "voxi0";
    kbLayout = "gb";
    locale = "en_GB.UTF-8";

    # Used by the LastFM rich presence plugin for Discord
    lastFmUsername = "voxi0";

    # State version
    # The first version of NixOS that was installed on this particular machine
    # It's used to maintain compatibility with app data (e.g. databases) created on older NixOS versions
    # This shouldn't be changed after the initial install for any reason even when NixOS is updated
    # See https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
    stateVersion = "26.05";
  };

  # A configured `pkgs` instance and a basic development environment
  systems = inputs.nixpkgs.lib.platforms.all;
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    # Configure a `pkgs` instance
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Provide the configured `pkgs` instance to `nix-wrapper-modules`
    wrappers.pkgs = pkgs;

    # Formatter and development environment
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [deadnix statix];
    };
  };
}
