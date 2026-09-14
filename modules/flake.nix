{inputs, ...}: {
  # Import flake-parts modules
  imports = with inputs; [
    flake-parts.flakeModules.modules
    wrappers.flakeModules.wrappers
    home-manager.flakeModules.home-manager
  ];

  flake = {
    username = "voxi0";
    kbLayout = "gb";
    timezone = "Europe/London";
    locale = "en_GB.UTF-8";
    lastFmUsername = "voxi0";
    stateVersion = "26.05";
  };

  systems = inputs.nixpkgs.lib.platforms.all;
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    # Configure `pkgs` instance
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        # Nix User Repository (NUR)
        inputs.nur.overlays.default
      ];
    };

    # Development tools for vodots
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [statix deadnix];
    };
  };
}
