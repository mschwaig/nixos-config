{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    functions = {
      lock = "swaylock -f -c 000000 $argv";
      authorize_dock = "sudo su -c \"echo 1 > /sys/bus/thunderbolt/devices/0-1/authorized\"";
      nwhich = "readlink -f (which $argv)";
    };
  };

}
