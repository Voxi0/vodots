{
  # Import all Nix modules
  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);

  # Dependencies
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake
    import-tree.url = "github:vic/import-tree";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # For configuring disk layouts and all using Nix
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declaratively configure Vencord
    nixcord.url = "github:kaylorben/nixcord";

    # Tool to customize the official Spotify client
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    # My personal Neovim configuration
    NixNvim = {
      url = "git+https://tangled.org/voxi0.tngl.sh/NixNvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
