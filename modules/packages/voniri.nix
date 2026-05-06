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
          spawn "${voctalia-shell}" "msg" "panel-toggle" "launcher";
        }

        // Open control center
        Mod+S hotkey-overlay-title="Open control center" repeat=false {
          spawn "${voctalia-shell}" "msg" "panel-toggle" "control-center";
        }
        Mod+Comma hotkey-overlay-title="Open settings" repeat=false {
          spawn "${voctalia-shell}" "msg" "settings-toggle";
        }

        // Volume control
        Mod+Shift+Up hotkey-overlay-title="Increase volume by 3%" allow-when-locked=true {
          spawn "${voctalia-shell}" "msg" "volume-up" "3";
        }
        Mod+Shift+Down hotkey-overlay-title="Decrease volume by 3%" allow-when-locked=true {
          spawn "${voctalia-shell}" "msg" "volume-down" "3";
        }
        Mod+Shift+M hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "msg" "volume-mute";
        }
        XF86AudioRaiseVolume hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "msg" "volume-up" "3";
        }
        XF86AudioLowerVolume hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "msg" "volume-down" "3";
        }
        XF86AudioMute hotkey-overlay-title="Mute audio" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "msg" "volume-mute";
        }

        // Brightness control
        Mod+Ctrl+Up hotkey-overlay-title="Increase brightness by 3%" allow-when-locked=true {
          spawn "${voctalia-shell}" "msg" "brightness-up" "current" "3";
        }
        Mod+Ctrl+Down hotkey-overlay-title="Decrease brightness by 3%" allow-when-locked=true {
          spawn "${voctalia-shell}" "msg" "brightness-down" "current" "3";
        }
        XF86MonBrightnessUp hotkey-overlay-title="Increase brightness by 3%" allow-when-locked=true {
          spawn "${voctalia-shell}" "msg" "brightness-up" "current" "3";
        }
        XF86MonBrightnessDown hotkey-overlay-title="Decrease brightness by 3%" allow-when-locked=true {
          spawn "${voctalia-shell}" "msg" "brightness-down" "current" "3";
        }

        // Lock screen
        Mod+L hotkey-overlay-title="Lock screen" repeat=false {
          spawn "${voctalia-shell}" "msg" "screen-lock";
        }
        Mod+Shift+E hotkey-overlay-title="Toggle powermenu" repeat=false {
          spawn "${voctalia-shell}" "msg" "panel-toggle" "session";
        }

        // Media player control
        Mod+Shift+N hotkey-overlay-title="Skip to next track" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "msg" "media" "next";
        }
        Mod+Shift+P hotkey-overlay-title="Skip to previous track" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "msg" "media" "previous";
        }
        Mod+Shift+Space hotkey-overlay-title="Play/Puase current track" allow-when-locked=true repeat=false {
          spawn "${voctalia-shell}" "msg" "media" "toggle";
        }

        // Open wallpaper/emoji picker
        Mod+W hotkey-overlay-title="Browse wallpapers" repeat=false {
          spawn "${voctalia-shell}" "msg" "panel-toggle" "wallpaper";
        }

        // Open clipboard/notification history
        Mod+Y hotkey-overlay-title="Open clipboard history" repeat=false {
          spawn "${voctalia-shell}" "msg" "panel-toggle" "clipboard";
        }
      }
    '';
  };
}
