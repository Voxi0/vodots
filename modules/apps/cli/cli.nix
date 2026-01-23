{
  flake.modules.homeManager.cli = {pkgs, ...}: {
    home = {
      # Globally enable shell integration for all supported shells
      shell.enableShellIntegration = true;

      # Useful CLI utils
      packages = with pkgs; [wget tldr cava];
    };

    # Useful CLI utils
    programs = {
      # Modern `cd` and `ls` replacement
      zoxide.enable = true;
      eza.enable = true;

      # Use your preferred shell in all Nix shells
      nix-your-shell.enable = true;

      # Shell prompt
      starship = {
        enable = true;

        # Fish shell specific
        enableTransience = true;
        enableInteractive = true;
      };
    };
  };
}
