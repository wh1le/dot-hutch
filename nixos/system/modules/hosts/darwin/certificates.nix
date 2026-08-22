{ config, pkgs, ... }:
let
  caBundle = "/etc/ssl/certs/nix-corp-bundle.pem";
  corpCa = "${config.users.users.${config.my.username}.home}/.secrets/corp-ca.pem";
  screenshotDir = "${config.users.users.${config.my.username}.home}/Pictures/screenshots";
in
{
  # Trust the inspecting proxy in every Nix-provided tool.
  # environment.variables = {
  #   NIX_SSL_CERT_FILE = caBundle;
  #   SSL_CERT_FILE = caBundle;
  #   GIT_SSL_CAINFO = caBundle;
  #   CURL_CA_BUNDLE = caBundle;
  # };

  # Build a CA bundle from nixpkgs and the local corporate CA. If the local
  # CA is unavailable, include certificates from the System keychain instead.
  system.activationScripts.extraActivation.text = ''
    umask 022
    caTmp="$(mktemp)"
    cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt > "$caTmp"
    if [ -f ${corpCa} ]; then
      cat ${corpCa} >> "$caTmp"
    else
      /usr/bin/security find-certificate -a -p /Library/Keychains/System.keychain >> "$caTmp" 2>/dev/null || true
    fi
    /usr/bin/install -m 0644 "$caTmp" ${caBundle}
    rm -f "$caTmp"

    /usr/bin/install -d -m 0755 \
      -o ${config.my.username} -g staff ${screenshotDir}
  '';
}
