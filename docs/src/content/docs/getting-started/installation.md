---
title: Installation
description: How to intall vodots
sidebar:
  order: 2
---
## Fresh-Install
- First, fetch vodots `nix-shell -p git --run "git clone https://github.com/Voxi0/vodots"`.
- Open up `modules/flake/flake.nix` inside of the freshly cloned vodots to change some settings e.g. username>
- Choose a host. Look into `modules/hosts` inside of vodots to see available hosts and pick the one you want. You could also write your own one if you're up for it but that's slightly more complicated and will require more time and effort.
- Now `cd` into vodots to find a Makefile. Run `nix-shell -p gnumake` to install the Make utility of course.
- Run `make help` to see available instructions. I'm sure you can figure everything out from that.
- Go through [Post-Installation](/getting-started/post-installation).

## On An Existing Install
On a system that already has NixOS installed, the installation is far more straightforward.
- Fetch vodots `nix-shell -p git --run "git clone https://github.com/Voxi0/vodots"`.
- `cd` into vodots.
- Update the flake if you want with `nix flake update`.
- Run the following rebuild command
```bash
sudo nixos-rebuild boot \
	--flake ./#<the name of a host folder inside './modules/hosts/'>
	--extra-trusted-public-keys nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= \
    --extra-substituters https://nix-community.cachix.org
    --experimental-features "nix-command flakes"
```
