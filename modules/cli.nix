{
  flake.modules.homemanager.cli = {
    programs = {
      # Modern `ls` replacement
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
