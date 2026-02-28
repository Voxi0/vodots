hostname ?= $(error Please set a hostname like so -> make <install/format/gen-hardware-conf> hostname=<name of a folder in './modules/hosts/'>)
experimentalFeatures := --experimental-features "nix-command flakes"

# Default target
all: help

# Install NixOS and 'vodots'
.PHONY: install
install: format gen-hardware-conf
	@echo "Ensure 'modules/flake/flake.nix' sets your desired system username, keyboard layout and such"
	read -p "Press enter to proceed..."
	sudo nixos-install --flake ./#$(hostname)
	sudo nixos-enter
	@echo "Vodots is installed! You can now reboot your system"
	@echo "Note that the default user password is 'nixos' and to set timezone with 'timedatectl set-timezone'"

# Help screen
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make install hostname=<name of a folder in './modules/hosts/'>"
	@echo "  make format hostname=<name of a folder in './modules/hosts/'>"
	@echo "  make gen-hardware-conf hostname=<name of a folder in './modules/hosts/'>"

# Format the disk declaratively using Disko
.PHONY: format
format:
	@echo "Ensure 'disko.nix' has the desired disk layout and the `primaryDisk` is pointing to the correct drive before continuing"
	@echo "WARNING! ALL DATA ON THE DRIVE THAT `primaryDisk` IS POINTING TO WILL BE ERASED."
	@read -p "Press enter to proceed..."
	sudo nix $(experimentalFeatures) run github:nix-community/disko/latest -- \
		--mode disko ./modules/hosts/$(hostname)/disko.nix

# Generate hardware config
.PHONY: gen-hardware-conf
gen-hardware-conf:
	sudo nix run --option $(experimentalFeatures) nixpkgs#nixos-facter -- -o ./modules/hosts/$(hostname)/facter.json
