{self, ...}: {
  flake.wrappers.vongowm = {wlib, ...}: {
    imports = [wlib.wrapperModules.mangowc];
    configFile.path = ../../config/mangowm/config.conf;
    extraConfig = ''
      xkb_rules_layout=${self.kbLayout}
    '';
  };
}
