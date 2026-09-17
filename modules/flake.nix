{inputs, ...}: {
  # Import flake-parts modules
  imports = with inputs; [
    flake-parts.flakeModules.modules
    wrappers.flakeModules.wrappers
    home-manager.flakeModules.home-manager
  ];

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

    # Provide the configured `pkgs` instance to `nix-wrapper-modules`
    wrappers.pkgs = pkgs;

    # Development tools for vodots
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [statix deadnix];
    };
  };
}
