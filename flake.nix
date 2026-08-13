{
  # Import all Nix modules
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (let
    lib = inputs.nixpkgs.lib;

    # Include only Nix files not starting with "_"
    filteredFileset = lib.fileset.fileFilter
      (file: file.hasExt "nix" && !(lib.hasPrefix "_" file.name))
      ./modules;

    # List of filepaths
    modulePaths = lib.fileset.toList filteredFileset;
  in {
    imports = modulePaths;
  });

  # Dependencies
  inputs = {
    # Flake infrastructure
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Software repositories
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # For configuring disk layouts and all using Nix
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence
    preservation.url = "github:nix-community/preservation";

    # Secure Boot & Measured Boot for NixOS
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Weekly updated nix-index database for nixos-unstable
    # nix-index is a tool to quickly locate the package providing a certain file in nixpkgs
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Manages user specific stuff
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For wrapping programs with custom configuration and exporting them as a package
    # Allows you to configure user programs without relying on Home Manager specific modules
    # This is amazing because then your config stuff is basically independent and will work anywhere since it's just a package
    nix-wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Desktop shell
    noctalia.url = "github:noctalia-dev/noctalia";

    # Firefox extensions/plugins
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ungoogled chromium browser
    # helium = {
    #   url = "github:schembriaiden/helium-browser-nix-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Popular Firefox based browser
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declaratively configure Vencord
    nixcord.url = "github:FlameFlag/nixcord";

    # Tool to customize the official Spotify client
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # For setting up Minecraft servers
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
}