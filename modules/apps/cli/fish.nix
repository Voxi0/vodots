{
  # Fish shell configuration
  flake.modules.nixos.fish = {pkgs, ...}: {
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
}
