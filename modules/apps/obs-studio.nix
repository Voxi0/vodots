{
  flake.modules.homeManager.obs-studio = {pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs # Allows you to screen capture on wlroots based Wayland compositors
        obs-pipewire-audio-capture # Audio device and application capture for OBS Studio using PipeWire
        vkcapture # Linux Vulkan/OpenGL game capture
        obs-vaapi # VAAPI support via GStreamer
        obs-gstreamer # OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio
      ];
    };
  };
}
