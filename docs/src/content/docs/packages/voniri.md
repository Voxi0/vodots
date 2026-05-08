---
title: "Voniri"
sidebar:
    order: 2
---
[Niri](https://github.com/niri-wm/niri) is a super cool Wayland compositor as it introduced the concept of a scrolling layout. In this layout, windows are arranged in columns on an infinite strip going to the right. Opening a new window never causes existing windows to resize. This allows you to open an infinite number of windows in the same workspace without running out of space on the screen compared to typical layouts where you could have about 3 windows open at most practically.

It's become increasingly popular and a great alternative for those who thinks that [Hyprland](https://hypr.land/) is too bloated and just crappy and whatnot.

Anyways, [voniri](https://github.com/Voxi0/vodots/blob/main/modules/packages/voniri.nix) simply wraps the Niri package with my own custom configuration obviously. It also pulls in [voctalia-shell](https://github.com/Voxi0/vodots/blob/main/modules/packages/voctalia-shell.nix) and [vokitty](https://github.com/Voxi0/vodots/blob/main/modules/packages/vokitty.nix) because they're both used in my configuration.

Reading the module and configuration should be fairly straightforward so I won't bother explaining anything and let you figure things out on your own.