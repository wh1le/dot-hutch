{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "strata";
      runtimeInputs = [ pkgs.coreutils pkgs.nix ];
      text = ''
        # Setup writes configs, a venv and build products, so it needs writable source.
        source_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/strata/${inputs.strata.rev}"
        if [ ! -d "$source_dir" ]; then
          mkdir -p "$(dirname "$source_dir")"
          cp -R --no-preserve=mode ${inputs.strata.outPath} "$source_dir"
        fi
        cd "$source_dir"

        if [ "''${1:-}" = setup ]; then
          shift
          exec nix develop ${inputs.strata.outPath} -c ./setup.sh "$@"
        fi
        if [ -x "$source_dir/.venv/bin/python" ]; then
          export STRATA_PYTHON="$source_dir/.venv/bin/python"
        fi
        exec nix develop ${inputs.strata.outPath} -c ./bin/strata "$@"
      '';
    })
  ];
}
