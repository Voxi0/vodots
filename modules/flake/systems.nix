{inputs, ...}: {
  systems = import inputs.systems;
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    # Configure a pkgs instance
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = with inputs; [
        nvdots.overlays.default
        nix-minecraft.overlay
      ];
    };

    # Helpful for developing the dotfiles
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [deadnix statix];
    };
  };
}
