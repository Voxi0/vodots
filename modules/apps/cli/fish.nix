{
  # Fish shell configuration
  flake.modules = {
    # NixOS specific
    nixos.fish = {pkgs, ...}: {
      programs = {
        fish.enable = true;
        bash.interactiveShellInit = ''
          if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
          fi
        '';
      };
    };

    # Home Manager specific
    homeManager.fish = {
      programs.fish = {
        enable = true;
        interactiveShellInit = ''set fish_greeting'';
      };
    };
  };
}
