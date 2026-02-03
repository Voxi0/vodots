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
      overlays = [inputs.nvdots.overlays.default];
    };

    # Helpful for developing the dotfiles
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [deadnix statix];
    };
  };
}
