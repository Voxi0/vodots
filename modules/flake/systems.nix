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
        nvdots.overlays.default
        nix-minecraft.overlay
      ];
    };

    # Formatter and basic dev environment for vodots
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShellNoCC {
      nativeBuildInputs = with pkgs; [deadnix statix];
    };
  };
}
