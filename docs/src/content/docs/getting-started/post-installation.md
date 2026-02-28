---
title: "Post-Installation"
desc: "Things to do after installing vodots"
sidebar:
    order: 3
---
- **Change the password** -> Change the initial password "nixos" to something else using `sudo passwd`.
- **Set your timezone** -> vodots avoids setting timezones so a user can easily set it imperatively. It's just a single command you have to run like, once anyways. Use `timedatectl set-timezone` to set your timezone to whatever e.g. `timedatectl set-timezone Europe/London` for if you're living in the United Kingdom. To know what timezone to use, I recommend googling a bit you'll probably find your answer.
- **Updating vodots** -> Just `cd` into vodots and do a `nix flake update`. I don't always update my flake so yeah.
- **Configuring stuff** -> Configure Niri, Kitty and DMS by yourself. Their configurations aren't managed by Nix. I'm still working on how they should be configured.
- **Check hosts** -> Go through the host configuration and make whatever changes you want e.g. adding/removing flake-parts modules to enable/disable functionality offered by vodots.
