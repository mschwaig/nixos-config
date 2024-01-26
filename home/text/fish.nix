{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    functions = {
      authorize_dock = "sudo su -c \"echo 1 > /sys/bus/thunderbolt/devices/0-1/authorized\"";
      nwhich = "readlink -f (which $argv)";
      find_booting_servers = "{pkgs.nmap}/bin/nmap -sV -p 2222 192.168.0.0/24";
    };
  };

}
