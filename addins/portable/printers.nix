{ config, pkgs, ... }:

{
  # this snippet enables network printer support as described here:
  # https://nixos.wiki/wiki/Printing

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplipWithPlugin ];
  };
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;
  services.system-config-printer.enable = true;
}
