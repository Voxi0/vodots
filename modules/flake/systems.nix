{inputs, ...}: {
  systems = import inputs.systems;
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    # Nixpkgs instance
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        # A nice module that allows one to quickly and easily set up multiple Minecraft servers
        inputs.nix-minecraft.overlay

        # Lix - A better fork of Nix
        (_: prev: {
          inherit
            (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];
    };

    # Set the `pkgs` instance for all nix-wrapper modules or whatever
    wrappers.pkgs = pkgs;

    # Formatter and basic dev environment for vodots
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [deadnix statix];
    };
  };
}