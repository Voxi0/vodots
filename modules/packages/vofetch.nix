{
  flake.wrappers.vofetch = {wlib, ...}: {
    imports = [wlib.wrapperModules.fastfetch];
    settings = builtins.fromJSON ''
      {
        "display": {
          "color": "red",
          "separator": ""
        },
        "logo": {
          "type": "small",
          "padding": {
            "right": 2
          }
        },
        "modules": [
          {
            "format": "{user-name}",
            "key": " ",
            "type": "title"
          },
          {
            "format": "{3}",
            "key": " ",
            "type": "os"
          },
          {
            "format": "{1} {2}",
            "key": " ",
            "type": "kernel"
          },
          {
            "format": "{6}",
            "key": " ",
            "type": "shell"
          },
          {
            "key": "󱂬 ",
            "type": "wm"
          },
          {
            "key": "󱂬 ",
            "type": "de"
          },
          {
            "format": "{5}",
            "key": " ",
            "type": "terminal"
          }
        ]
      }
    '';
  };
}