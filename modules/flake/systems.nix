{self, ...}: {
  systems = import self.inputs.systems;
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    # Configure a pkgs instance
    _module.args.pkgs = import self.inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Helpful for developing the dotfiles
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [deadnix statix];
    };
  };
}
