{self, ...}: {
  # Scrolling Wayland compositor
  flake.wrappers.voniri = {
    wlib,
    lib,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    niriConfigDir = ../../config/niri;
  in {
    imports = [wlib.wrapperModules.niri];
    extraPackages = [pkgs.xwayland-satellite];
    "config.kdl".content = let
      voctalia-shell = lib.getExe self.packages.${system}.voctalia-shell;
    in ''
      // General config - Super basic stuff e.g. environment variables
      include "${niriConfigDir}/config.kdl";

      // Autostart
      spawn-at-startup "${voctalia-shell}";

      // Input config
      input {
        mod-key "Super";
        keyboard {
          numlock;
          xkb {
            layout "gb";

            // Remap the caps lock key into escape key
            // Very handy for Neovim
            options "caps:escape";
          }
        }
        touchpad {
          tap;
          natural-scroll;
        }
      }

      // Keybindings
      // Mainly Noctalia shell related
      binds {
        // Launch the terminal
        Mod+Return hotkey-overlay-title="Launch the terminal emulator" repeat=false {
          spawn "${lib.getExe self.packages.${system}.vokitty}";
        }

        // Open the application launcher
        Mod+D hotkey-overlay-title="Open the app launcher" repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "launcher" "toggle";
        }

        // Open control center or settings
        Mod+S hotkey-overlay-title="Open control center" {
          spawn-sh "${voctalia-shell} ipc call controlCenter toggle";
        }
        Mod+Comma hotkey-overlay-title="Open settings" {
          spawn-sh "${voctalia-shell} ipc call settings toggle";
        }

        // Volume control
        Mod+Shift+Up hotkey-overlay-title="Increase volume" allow-when-locked=true {
          spawn "${voctalia-shell}" "ipc" "call" "volume" "increase";
        }
        Mod+Shift+Down hotkey-overlay-title="Decrease volume" allow-when-locked=true {
          spawn "${voctalia-shell}" "ipc" "call" "volume" "decrease";
        }
        Mod+Shift+M hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "volume" "muteOutput";
        }
        XF86AudioRaiseVolume hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "volume" "increase";
        }
        XF86AudioLowerVolume hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "volume" "decrease";
        }
        XF86AudioMute hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "volume" "muteOutput";
        }

        // Brightness control
        Mod+Ctrl+Up hotkey-overlay-title="Increase brightness" allow-when-locked=true {
          spawn "${voctalia-shell}" "ipc" "call" "brightness" "increase";
        }
        Mod+Ctrl+Down hotkey-overlay-title="Decrease brightness" allow-when-locked=true {
          spawn "${voctalia-shell}" "ipc" "call" "brightness" "decrease";
        }
        XF86MonBrightnessUp hotkey-overlay-title="Decrease brightness" allow-when-locked=true {
          spawn "${voctalia-shell}" "ipc" "call" "brightness" "increase";
        }
        XF86MonBrightnessDown hotkey-overlay-title="Decrease brightness" allow-when-locked=true {
          spawn "${voctalia-shell}" "ipc" "call" "brightness" "decrease";
        }

        // Lock screen
        Mod+L hotkey-overlay-title="Lock screen" repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "lockScreen" "lock";
        }
        Mod+Shift+E hotkey-overlay-title="Toggle powermenu" repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "powermenu" "toggle";
        }

        // Media player control
        Mod+Shift+N hotkey-overlay-title="Skip to next track" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "media" "next";
        }
        Mod+Shift+P hotkey-overlay-title="Skip to previous track" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "media" "previous";
        }
        Mod+Shift+Space hotkey-overlay-title="Play/Puase current track" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "media" "playPause";
        }

        // Open wallpaper/emoji picker
        Mod+W hotkey-overlay-title="Browse wallpapers" repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "wallpaper" "toggle";
        }
        Mod+E hotkey-overlay-title="Open emoji picker" repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "launcher" "emoji";
        }

        // Open clipboard/notification history
        Mod+Y hotkey-overlay-title="Open clipboard history" repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "launcher" "clipboard";
        }
        Mod+N hotkey-overlay-title="Open notification centre" repeat=false {
          spawn "${voctalia-shell}" "ipc" "call" "notifications" "toggleHistory";
        }
      }
    '';
  };
}
