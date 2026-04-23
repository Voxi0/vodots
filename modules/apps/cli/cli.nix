{
  flake.modules.nixos.cli = {pkgs, ...}: {
    programs = {
      # Modern `cd` replacement
      zoxide.enable = true;
    };
  };

  # Useful CLI utils
  flake.modules.homeManager.cli = {pkgs, ...}: {
    home = {
      packages = with pkgs; [unzip wget nurl tldr cava];
      shellAliases = {
        "l" = "eza -alh";
        "ls" = "eza";
        "la" = "eza -a";
        "lla" = "eza -lla";
      };
    };
    programs = {
      # Modern `cd` and `ls` replacement
      zoxide.enable = true;
      eza = {
        enable = true;
        extraOptions = ["--icons=always"];
      };

      # Use your preferred shell in all Nix shells
      nix-your-shell.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
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
    };
  };
}
