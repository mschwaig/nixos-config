{ pkgs, ... }: {
  services.kanshi = {
    enable = true;
    profiles = {
      hydralisk-home-dell = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD35335TS";
            status = "enable";
            mode = "1920x1200";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD36A1KPS";
            status = "enable";
            mode = "1920x1200";
            position = "1920,0";
          }
        ];
      };
      mutalisk-home-dell = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD35335TS";
            status = "enable";
            mode = "1920x1200";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD36A1KPS";
            status = "enable";
            mode = "1920x1200";
            position = "1920,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          }
        ];
      };
      mutalisk-home-dell-incomplete = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD35335TS";
            status = "disable";
          }
          {
            # TODO: set subpixl hinting?
            # exec sway output eDP-1 subpixel vrgb
            criteria = "Unknown 0x058B 0x00000000";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
            scale = 2.0;
          }
        ];
      };
      mutalisk-solo = {
        outputs = [
          {
            # TODO: set subpixl hinting?
            # exec sway output eDP-1 subpixel vrgb
            criteria = "Unknown 0x058B 0x00000000";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
            scale = 2.0;
          }
        ];
      };
      jku-streaming = {
        outputs = [
          {
            criteria = "Unknown HD60 S+ 0x00000000";
            status = "enable";
            mode = "1920x1080";
            position = "0,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "enable";
            mode = "2560x1440";
            position = "0,1080";
            scale = 2.0;
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          }
        ];
      };
      jku-workplace = {
        outputs = [
          {
            criteria = "Acer Technologies B276HUL T59EE0018501";
            status = "enable";
            mode = "2560x1440";
            position = "2560,0";
          }
          {
            criteria = "DP-4";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          }
        ];
      };
      jku-workplace-2 = {
        outputs = [
          {
            criteria = "Acer Technologies B276HUL T59EE0018501";
            status = "enable";
            mode = "2560x1440";
            position = "2560,0";
          }
          {
            criteria = "DP-6";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          } # TODO: enalbe onboard screen again
            # (disabled because after locking the screen
            # I cannot turn this on one again)
        ];
      };
    };
  };

}
