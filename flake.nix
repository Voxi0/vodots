{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Nix User Repository (NUR)
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative management of non-volatile system state
    preservation.url = "github:nix-community/preservation";

    # Declarative disk layouts in Nix
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modules to wrap packages with configuration directly
    wrappers = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager - Manages user-level stuff e.g. dotfiles
    home-manager.url = "github:nix-community/home-manager";

    # Mango Wayland compositor
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declaratively manage Discord
    nixcord.url = "github:4evy/nixcord";

    ######################
    ### NEOVIM PLUGINS ###
    ######################
    # Autocompletion
    blink-cmp-nvim.url = "github:saghen/blink.cmp";

    # Discord rich presence (RPC)
    cord-nvim = {
      url = "github:vyfor/cord.nvim";
      flake = false;
    };

    # Convert GIFs into ASCII stuff to display as a banner in Neovim's dashboard
    milli-nvim = {
      url = "github:Amansingh-afk/milli.nvim";
      flake = false;
    };
  };

  # Import all Nix modules except ones that start with an "_"
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (let
      # Alias for `inputs.nixpkgs.lib`
      inherit (inputs.nixpkgs) lib;

      # Find all Nix files in `modules` that don't start with an underscore
      files = lib.fileset.fileFilter (file: file.hasExt "nix" && !(lib.hasPrefix "_" file.name)) ./modules;
    in {
      # Convert the set of files into a list so we can import all the Nix modules
      imports = lib.fileset.toList files;

      # Global variables
      flake = {
        username = "voxi0";
        kbLayout = "gb";
        timezone = "Europe/London";
        locale = "en_GB.UTF-8";
        lastFmUsername = "voxi0";
        stateVersion = "26.05";
      };
    });
}
