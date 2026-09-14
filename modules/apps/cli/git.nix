{
  flake.modules.homeManager = {
    # Git and LazyGit TUI
    git = {
      programs = {
        git.enable = true;
        lazygit.enable = true;
      };
    };

    # Working with GitHub from the CLI
    github = {
      programs = {
        gh.enable = true;
        gh-dash.enable = true;
      };
    };
  };
}
