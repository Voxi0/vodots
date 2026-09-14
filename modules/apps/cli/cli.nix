{
  flake.modules.homeManager.cli = {pkgs, ...}: {
    home.packages = with pkgs; [
      unzip wget curl nurl
    ];

    programs = {
      # Nix helper
      nh.enable = true;

      # Modern `cd`, `cat` and `ls` replacement
      zoxide.enable = true;
      bat.enable = true;
      eza = {
        enable = true;
        icons = "auto";
        git = true;
      };

      # Shell prompt
      starship = {
        enable = true;

        # Fish shell specific
        enableTransience = true;
        enableInteractive = true;

        # Don't put a newline before the prompt
        settings.add_newline = false;
      };

      # Use your current shell in a Nix shell
      nix-your-shell = {
        enable = true;
        nix-output-monitor.enable = true; # Pipe `nix build` output through NOM to get additional info while building
      };
    };
  };
}
