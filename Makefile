hostname ?= $(error Please set a hostname like so -> make <install/format/gen-hardware-conf> hostname=<name of a folder in './modules/hosts/'>)
experimentalFeatures := --extra-experimental-features "nix-command flakes"

# Colors
YELLOW=\033[1;33m
GREEN=\033[1;32m
RED=\033[1;31m
CYAN=\033[1;36m
QUESTION=\033[1;34m
NC=\033[0m

# Default target
all: help

# Check if the current distribution is NixOS
.PHONY: checkNixOS
checkNixOS:
	@if grep -qi nixos /etc/os-release; then \
		echo -e "${GREEN}Fire"; \
	else \
		echo -e "${RED}Boo"; \
		exit 1; \
	fi

# Install NixOS and 'vodots'
.PHONY: install
install: format gen-hardware-conf
	@echo "Ensure 'modules/flake/flake.nix' sets your desired system username, keyboard layout and such"
	@echo ""
	@read -p "Press enter to proceed..."
	sudo nixos-install \
		--flake ./#$(hostname) \
		--option extra-substituters "https://noctalia.cachix.org" \
		--option extra-trusted-public-keys "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
	sudo nixos-enter
	@echo -e "${GREEN}Vodots is installed! You can now reboot your system"
	@echo -e "${GREEN}The default user password is 'nixos' and set the timezone with 'timedatectl set-timezone' after booting"

# Help screen
.PHONY: help
help:
	@echo -e "${CYAN}Available commands:"
	@echo -e "\t${NC}make install hostname=<name of a folder in './modules/hosts/'>"
	@echo -e "\t${NC}make format hostname=<name of a folder in './modules/hosts/'>"
	@echo -e "\t${NC}make gen-hardware-conf hostname=<name of a folder in './modules/hosts/'>"

# Format the disk declaratively using Disko
.PHONY: format
format:
	@echo -e "${CYAN}Ensure that 'disko.nix' exists with the desired disk layout and that 'primaryDisk' is set to the drive to install NixOS on before continuing"
	@echo -e "${RED}WARNING! ALL DATA ON THE DRIVE 'primaryDisk' WILL BE ERASED."
	@echo ""
	@read -p "Press enter to proceed..."
	sudo nix $(experimentalFeatures) run github:nix-community/disko/latest -- \
		--mode disko ./modules/hosts/$(hostname)/_disko.nix

# Generate hardware config
.PHONY: gen-hardware-conf
gen-hardware-conf:
	sudo nix run $(experimentalFeatures) nixpkgs#nixos-facter -- -o ./modules/hosts/$(hostname)/facter.json
	sudo chmod 644 ./modules/hosts/$(hostname)/facter.json