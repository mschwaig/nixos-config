{ ... }:

{
  services.snapper = {
    snapshotRootOnBoot = true;
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "mschwaig" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 0;
        TIMELINE_LIMIT_WEEKLY = 2;
      };
      root = {
        SUBVOLUME = "/";
        ALLOW_USERS = [ "mschwaig" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 24;
        TIMELINE_LIMIT_DAILY = 0;
        TIMELINE_LIMIT_WEEKLY = 2;
      };
    };
  };
}
