{
  flake.modules = {
    # NixOS specific
    nixos.cli = {pkgs, ...}: {
      programs = {
        fish = {
          enable = true;
          interactiveShellInit = ''set fish_greeting'';
        };
        bash.interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
    };
    # Home Manager specific
    homeManager.cli = {pkgs, ...}: {
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

        # File manager
        yazi = {
          enable = true;
          settings = {
            input.cursor_blink = false;
            mgr = {
              ratio = [1 2 3]; # Parent, current and preview windows width
              show_hidden = false;
              show_symlink = false;
              sort_by = "natural";
              sort_reverse = false;
              sort_sensitive = true;
              linemode = "size";
            };
            preview = {
              wrap = "no";
              image_filter = "nearest";
              image_quality = 50;
            };
          };
        };
      };
    };
  };
}
