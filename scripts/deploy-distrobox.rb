#!/usr/bin/env ruby

require "open3"

module Distrobox
  PACKAGE_MANAGERS = {
    pacman: "sudo pacman -Syu --noconfirm && sudo pacman -S --needed --noconfirm",
    apt: "sudo apt update && sudo apt install -y",
  }.freeze

  DISTROS = {
    arch: {
      image: "docker.io/library/archlinux:latest",
      package_manager: :pacman,
      packages: %w[
        nodejs
        npm
        eza
        fzf
        zsh
        rust
      ],
      run_commands: [
        { 
          command: "curl -fsSL https://claude.ai/install.sh | bash",
          unless: "test -x $HOME/.local/bin/claude" 
        },
        {
          command: "cargo install cfait",
          unless: "test -x $HOME/.local/share/cargo/bin/cfait"
        },
        {
          command: "curl -fsSL https://cli.kiro.dev/install | bash",
          unless: "test -x $HOME/.local/bin/kiro-cli"
        },
      ],
      export_bins: %w[
        claude
        kiro-cli
      ],
    },
  }.freeze

  class Shell
    Result = Struct.new(:stdout, :stderr, :status)

    def self.execute(*)
      Result.new(*Open3.capture3(*))
    end

    def self.run!(*command)
      result = execute(*command)
      abort("FAIL: #{command.join(" ")}\n#{result.stderr}") unless result.status.success?
      result.stdout
    end

    def self.ok?(*)
      execute(*).status.success?
    end

    def self.stream!(*command)
      abort("FAIL: #{command.join(" ")}") unless system(*command)
    end

    def self.in_container(name, script) = stream!("distrobox", "enter", "--clean-path", name, "--", "bash", "-c", script)
    def self.in_container?(name, script) = ok?("distrobox", "enter", "--clean-path", name, "--", "bash", "-c", script)
  end

  class Packages
    def self.install(name, distro)
      prefix = PACKAGE_MANAGERS.fetch(distro[:package_manager])
      Shell.in_container(name, "#{prefix} #{distro[:packages].join(" ")}")
    end
  end

  class Exporter
    def self.export_all(name, bins)
      bins.each do |bin|
        local_path = File.join(Dir.home, ".local", "bin", bin)
        next Shell.in_container(name,
          "[ -x /usr/bin/#{bin} ] && distrobox-export --bin /usr/bin/#{bin} --export-path ~/.local/bin") unless File.exist?(local_path)

        result = Shell.execute("which", bin)
        unless result.status.success? && result.stdout.strip == local_path
          puts "[error] #{bin} exists in ~/.local/bin but provided by NixOS - skipping"
        end
      end
    end
  end

  def self.install
    abort("distrobox not found. Install distrobox first.") unless Shell.ok?("which", "distrobox")

    DISTROS.each do |name, distro|
      name = name.to_s

      if Shell.execute("distrobox", "list").stdout.match?(/\| #{name}\s+\|/)
        puts "[skip] container #{name} already exists"
      else
        puts "[create] #{name}"
        Shell.stream!("distrobox", "create", "--yes", "--name", name, "--image", distro[:image])
      end

      Packages.install(name, distro)
      distro[:run_commands].each do |entry|
        next if entry[:unless] && Shell.in_container?(name, entry[:unless])

        Shell.in_container(name, entry[:command])
      end
      Exporter.export_all(name, distro[:export_bins])
    end
  end
end

Distrobox.install
