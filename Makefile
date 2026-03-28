hostname ?= $(error Please set a hostname like so -> make <install/format/gen-hardware-conf> hostname=<name of a folder in './modules/hosts/'>)
experimentalFeatures := --extra-experimental-features "nix-command flakes"

# Default target
all: help

# Install NixOS and 'vodots'
.PHONY: install
install: format gen-hardware-conf
	@echo "Ensure 'modules/flake/flake.nix' sets your desired system username, keyboard layout and such"
	@echo ""
	@read -p "Press enter to proceed..."
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
	@echo "Ensure that 'disko.nix' exists with the desired disk layout and that 'primaryDisk' is set to the drive to install NixOS on before continuing"
	@echo "WARNING! ALL DATA ON THE DRIVE 'primaryDisk' WILL BE ERASED."
	@echo ""
	@read -p "Press enter to proceed..."
	sudo nix $(experimentalFeatures) run github:nix-community/disko/latest -- \
		--mode disko ./modules/hosts/$(hostname)/_disko.nix

# Generate hardware config
.PHONY: gen-hardware-conf
gen-hardware-conf:
	sudo nix run $(experimentalFeatures) nixpkgs#nixos-facter -- -o ./modules/hosts/$(hostname)/facter.json
	sudo chmod 644 ./modules/hosts/$(hostname)/facter.json
