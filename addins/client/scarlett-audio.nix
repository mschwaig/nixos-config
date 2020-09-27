{ config, pkgs, ... }:

{
  boot.extraModprobeConfig = ''
    options snd_usb_audio device_setup=1 
  '';
}
