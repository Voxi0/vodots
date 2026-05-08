{self, ...}: {
  flake.wrappers.vongowc = {
    wlib,
    lib,
    pkgs,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    voctaliaShell = lib.getExe self.packages.${system}.voctalia-shell;
  in {
    autostart_sh = ''
      ${lib.getExe pkgs.xdg-desktop-portal-wlr}
      ${voctaliaShell}
    '';
    configFile.path = ../../config/mangowc/config.conf;
  };
}
