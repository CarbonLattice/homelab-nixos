{ modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
  ];

  installer.cloneConfig = false;

  users.users.root.openssh.authorizedKeys.keyFiles = [ ../authorized_keys ];

  # Some machines (the Dell OptiPlexes in this lab) boot the installer with their clock years in the past
  # (2019). Until NTP has set it, TLS to cache.nixos.org and GitHub fails with "certificate is not yet valid",
  # `nix build` exits 1, the agent stops (Restart = "no") and Nixie marks the host as failed.
  # Hold the agent back until the clock is plausible (2026-01-01 or later). A machine with a sane clock
  # passes immediately; one that never gets NTP starts the agent after 5 minutes anyway.
  systemd.services.nixie-agent.serviceConfig = {
    TimeoutStartSec = "10min";
    ExecStartPre = pkgs.writeShellScript "wait-for-clock" ''
      for _ in $(${pkgs.coreutils}/bin/seq 1 300); do
        if [ "$(${pkgs.coreutils}/bin/date +%s)" -ge 1767225600 ]; then
          exit 0
        fi
        ${pkgs.coreutils}/bin/sleep 1
      done
      echo "clock still not set after 300 s, starting the agent anyway" >&2
    '';
  };

  system.stateVersion = "25.05";
}
