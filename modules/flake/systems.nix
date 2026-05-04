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
      overlays = with inputs; [
        nix-minecraft.overlay
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
