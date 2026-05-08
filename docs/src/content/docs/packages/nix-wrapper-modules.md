---
title: "Nix Wrapper Modules"
sidebar:
    order: 1
---
vodots uses [nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules) which is a Nix library, to create wrapped executables via the module system. This allows one to wrap any package with their own configuration and stuff and distribute it as a package that can run anywhere with Nix installed instead of relying on NixOS or Home Manager modules specifically.

vodots exports multiple packages wrapped with my own configuration. You can try any one of the packages temporarily using the following command - `nix run github:Voxi0/vodots#<package name>`.

## Available Packages

<div align=center><p><strong>Wayland Compositors</strong></p></div>

- **[voniri](https://github.com/Voxi0/vodots/blob/main/modules/packages/voniri.nix)**: [Niri](https://github.com/niri-wm/niri), a cool and increasingly popular Wayland compositor. I really love the scrolling concept and prefer it over tiling honestly.
- **[vongowc](https://github.com/Voxi0/vodots/blob/main/modules/packages/vongowc.nix)**: [Mango](https://github.com/mangowm/mango), a practical and powerful Wayland compositor based on [DWL](https://codeberg.org/dwl/dwl) which is basically [DWM](https://dwm.suckless.org/) for Wayland.

<div align=center><p><strong>Shells</strong></p></div>

- **[voctalia-shell](https://github.com/Voxi0/vodots/blob/main/modules/packages/voctalia-shell.nix)**: [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell), a beautiful shell made using [Quickshell](https://quickshell.org) with widgets and stuff which can transform a window manager or Wayland compositor or whatever into a fully-blown desktop environment.

<div align=center><p><strong>CLI Utilities/Apps</strong></p></div>

- **[vofetch](https://github.com/Voxi0/vodots/blob/main/modules/packages/vofetch.nix)**: [Fastfetch](https://github.com/noctalia-dev/noctalia-shell), just a simple sysfetch utility to show off to people I suppose.
- **[vonvim](https://github.com/Voxi0/vodots/blob/main/modules/packages/vonvim.nix)**: [Neovim](https://neovim.io/), an amazing modern CLI text/code editor which improved on [Vim](https://www.vim.org/) with tons of cool stuff.

<div align=center><p><strong>Applications</strong></p></div>

- **[vokitty](https://github.com/Voxi0/vodots/blob/main/modules/packages/vokitty.nix)**: [Kitty](https://github.com/kovidgoyal/kitty), a fast and feature-rich terminal emulator.