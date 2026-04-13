---
title: Installation
description: How to install vodots
sidebar:
  order: 2
---
## Fresh-Install
```bash
# Launch a shell with Git (to fetch vodots) and the GNU Make utility (to use the Makefile provided by vodots)
nix-shell -p git gnumake

# Fetch vodots
git clone https://github.com/Voxi0/vodots && cd vodots

# Change some global/common stuff e.g. username
nano "modules/flake/flake.nix"

# Hosts are defined in `modules/hosts` with each host being for a different installation/machine for example
# Just choose whichever one you want
# Look at the following files and adjust them to your liking

# The host configuration e.g. what apps are installed for said host
nano "modules/hosts/<hostname>/default.nix"

# The disk layout defined for said host
nano "modules/hosts/<hostname>/_disko.nix"

# You're ready to install NixOS with vodots!
# Run the following to see available Makefile targets
# I'm sure you can figure everything out from here on out
make help
```
- Go through [Post-Installation](/getting-started/post-installation).

## On An Existing Install
On a system that already has NixOS installed, the installation is far more straightforward.
```bash
# Fetch vodots
nix-shell -p git --run "git clone https://github.com/Voxi0/vodots" && cd vodots

# Update the flake if you want to have the latest and greatest software
nix flake update

# Rebuild your system using vodots
sudo nixos-rebuild boot \
	--flake ./#<the name of a host folder inside "./modules/hosts/">
	--extra-trusted-public-keys nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= \
    --extra-substituters https://nix-community.cachix.org
    --experimental-features "nix-command flakes"
```
