# PiChamber — browser UI + session daemon for the Pi coding agent.
#
# Upstream ships an official, pinned-Bun image, so nothing is built locally:
#   ghcr.io/ryderasking/pichamber:1.0.2
#
# Control (rootful Podman, managed by systemd):
#   sudo systemctl start podman-pichamber
#   sudo systemctl stop  podman-pichamber
#   sudo podman logs -f pichamber
#   xdg-open http://127.0.0.1:5000
#
# Password: the image binds 0.0.0.0 inside the container and refuses to boot
# without PICHAMBER_UI_PASSWORD. Store it in sops, then rebuild:
#   sops /var/lib/sops-nix/secrets/nix.yaml   # add: pichamber/ui_password: "<pw>"
#
# Persistent host state (~/.local/share/pichamber):
#   config/      PiChamber settings, credentials, projects, themes
#   local/       XDG state/cache the agent runtime may use
#   ssh/         auto-generated deploy key; add .pub to GitHub before pushing
#   workspaces/  host repos the agent may edit (default: ~/Code)
#
# Pi agent state is NOT copied: ~/.pi/agent is bind-mounted live from the host
# so PiChamber sees the same models, provider auth, sessions (history),
# skills, prompts and extensions as desktop `pi`. The three config files in
# that dir are symlinks into the dotfiles repo, so the repo's .pi dir is also
# mounted at its real absolute path or those symlinks would dangle.
#
# Isolation (this is an untrusted-node-code container):
#   - runs as your uid, root entrypoint branch skipped
#   - --cap-drop=ALL + no-new-privileges (no setuid/setgid escalation)
#   - read-only root filesystem; only /tmp and ~/.cache are tmpfs scratch
#   - no host ~/.ssh, ~/.gnupg, ~/.config/git, no Docker/Podman socket, no
#     devices
#   - published on 127.0.0.1 only, hard pids/memory/cpu caps
#
# NOTE: the host Pi agent dir is mounted read-write, so the container can
# change host Pi config/credentials (and could drop an extension that desktop
# `pi` would later execute). Do not run desktop `pi` and PiChamber against the
# same agent dir at the same time; both write sessions/settings.
#
# Residual risk: the agent legitimately needs network egress (model APIs, git)
# and can read everything under ~/Code. Anything readable is exfiltratable.
# If you need stronger separation, point `workspacesDir` at a dedicated dir.
#
# If the container fails to start with an EROFS/"read-only file system" error,
# the app is writing somewhere unexpected: drop "--read-only", find the path in
# the logs, then add a tmpfs or state mount for it and restore --read-only.

{ config, ... }:
let
  inherit (config.my) username;

  home = config.users.users.${username}.home;

  user = config.users.users.${username};

  # NixOS leaves `uid`/`gid` null for auto-allocated normal users (the real id
  # is chosen at activation). Without a fallback `toString null` yields "",
  # podman then keeps the image's root user, and the entrypoint's root branch
  # runs `chown` — which fails under --cap-drop=ALL. This host's first normal
  # user is 1000:1000.
  uid = toString (if user.uid == null then 1000 else user.uid);
  gid =
    let
      groupGid = config.users.groups.${user.group}.gid;
    in
    toString (if groupGid == null then 1000 else groupGid);

  stateDir = "${home}/.local/share/pichamber";
  workspacesDir = "${home}/Code";

  # Live-shared Pi agent dir (models, auth, sessions, skills, extensions).
  piAgentDir = "${home}/.pi/agent";
  # Real target of the models.json/auth.json/settings.json symlinks inside
  # piAgentDir; mounted at the same absolute path so they resolve in-container.
  dotfilesPiDir = "${home}/Code/dot-personal/home/.pi";

  port = 5000;
  # The image entrypoint hardcodes `serve --port 3000`; the container always
  # listens on 3000. Only the host-side port is configurable.
  containerPort = 3000;

  image = "ghcr.io/ryderasking/pichamber:1.0.2";
  secretName = "pichamber/ui_password";
in
{
  # --- secret: UI password -------------------------------------------------
  sops.secrets.${secretName} = {
    owner = "root";
    group = "root";
    mode = "0400";
  };

  # Rendered to /run (root-only), never to the world-readable Nix store.
  sops.templates."pichamber-env" = {
    owner = "root";
    group = "root";
    mode = "0400";
    content = ''
      PICHAMBER_UI_PASSWORD=${config.sops.placeholder.${secretName}}
      DEEPSEEK_API_KEY=${config.sops.placeholder."llm/ds"}
    '';
  };

  # --- host state dirs -----------------------------------------------------
  systemd.tmpfiles.rules = [
    "d ${stateDir} 0755 ${username} users -"
    "d ${stateDir}/config 0700 ${username} users -"
    "d ${stateDir}/local 0700 ${username} users -"
    "d ${stateDir}/ssh 0700 ${username} users -"
  ];

  # --- container -----------------------------------------------------------
  virtualisation.oci-containers = {
    backend = "podman";
    containers.pichamber = {
      inherit image;
      autoStart = true;

      ports = [ "127.0.0.1:${toString port}:${toString containerPort}" ];

      environmentFiles = [ config.sops.templates."pichamber-env".path ];

      volumes = [
        "${stateDir}/config:/home/pichamber/.config/pichamber"
        "${stateDir}/local:/home/pichamber/.local"
        "${stateDir}/ssh:/home/pichamber/.ssh"
        "${workspacesDir}:/home/pichamber/workspaces"

        # Host Pi agent state (live). The dotfiles .pi dir is mounted at its
        # real absolute path only so the symlinked config files resolve.
        "${piAgentDir}:/home/pichamber/.pi/agent"
        "${dotfilesPiDir}:${dotfilesPiDir}"
      ];

      extraOptions = [
        # Unprivileged from the start: the image entrypoint skips its root
        # branch, so no chown/setpriv and no capabilities are ever needed.
        "--user=${uid}:${gid}"
        "--cap-drop=ALL"
        "--security-opt=no-new-privileges"

        # Immutable rootfs; scratch space is tmpfs only.
        "--read-only"
        "--tmpfs=/tmp:rw,nosuid,nodev,noexec,size=256m"
        "--tmpfs=/home/pichamber/.cache:rw,nosuid,nodev,size=256m"

        # Resource ceilings (a runaway/infected agent cannot fork-bomb the host).
        "--pids-limit=2048"
        "--memory=4g"
        "--cpus=4"
        "--ipc=private"
      ];
    };
  };
}
