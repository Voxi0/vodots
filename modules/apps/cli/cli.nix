{
  # NixOS specific
  flake.modules.nixos.cli = {
    # Modern `cd` replacement
    programs.zoxide.enable = true;
  };

  # Home Manager specific
  flake.modules.homeManager.cli = {pkgs, ...}: {
    home = {
      packages = with pkgs; [unzip wget curl nurl tealdeer cava];
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
