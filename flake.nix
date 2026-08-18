{
  # Dependencies
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Wrap applications and such with configuration
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";

    # Weekly updated nix-index database for NixOS unstable
    # `nix-index` is a tool to quickly locate the package providing a certain file in `nixpkgs`
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manage disk layouts
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence
    preservation.url = "github:nix-community/preservation";

    # Manages user specific stuff
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop shell
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # Firefox extensions
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Discord
    nixcord.url = "github:4evy/nixcord";

    # Spotify
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # For hosting Minecraft servers
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # Custom Neovim plugins
    blink-cmp-nvim.url = "github:saghen/blink.cmp";
    cord-nvim = {
      url = "github:vyfor/cord.nvim";
      flake = false;
    };
    milli-nvim = {
      url = "github:Amansingh-afk/milli.nvim";
      flake = false;
    };
  };

  # Import all Nix modules
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (let
      # Alias
      lib = inputs.nixpkgs.lib;

      # Find all Nix files in `modules` that don't start with an underscore
      files = lib.fileset.fileFilter (file: file.hasExt "nix" && !(lib.hasPrefix "_" file.name)) ./modules;
    in {
      # Convert the set of files into a list so we can import all the Nix modules
      imports = lib.fileset.toList files;
    });
}
