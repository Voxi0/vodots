{self, ...}: {
  flake.wrappers.vongowc = {
    wlib,
    lib,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    voctaliaShell = lib.getExe self.packages.${system}.voctalia-shell;
  in {
    imports = [wlib.wrapperModules.mangowc];
    autostart_sh = ''
      ${lib.getExe pkgs.xdg-desktop-portal-wlr}
      ${voctaliaShell}
    '';
    configFile.path = ../../config/mangowc/config.conf;
  };
}