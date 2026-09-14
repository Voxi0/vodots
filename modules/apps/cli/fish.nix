{self, ...}: {
  # NixOS specific
  flake.modules.nixos.fish = {pkgs, ...}: {
    programs = {
      fish.enable = true;

      # Using fish as the login shell can cause compatibility issues
      # The ArchWiki presents another solution where Bash is kept as the system shell but having it exec fish when run interactively
      bash.interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    # Import Home Manager Fish shell stuff
    home-manager.users.${self.username}.imports = [self.modules.homeManager.fish];
  };

  # Home Manager specific
  flake.modules.homeManager.fish = {
    programs.fish = {
      enable = true;
      interactiveShellInit = "set fish_greeting";
    };
  };
}
