#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'fileutils'

PREVIEW_DIR = File.join(ENV.fetch('XDG_CACHE_HOME', File.join(Dir.home, '.cache')), 'quickshell/fzf-source/ruby-gems-previews')
FileUtils.mkdir_p(PREVIEW_DIR)

def fetch(path)
  uri = URI("https://rubygems.org#{path}")
  Net::HTTP.get(uri)
rescue StandardError
  nil
end

def format_preview(json)
  g = JSON.parse(json)
  lines = ["#{g['name']} (#{g['version']})"]
  lines << "    Author: #{g['authors']}"
  l = Array(g['licenses']).join(', ')
  lines << "    License: #{l}" unless l.empty?
  lines << "    Homepage: #{g['homepage_uri']}" if g['homepage_uri']&.length&.positive?
  lines << "    Source: #{g['source_code_uri']}" if g['source_code_uri']&.length&.positive?
  lines << "    Downloads: #{g['downloads']}"
  info = g['info']&.strip
  lines << "\n#{info}" if info && !info.empty?
  lines.join("\n")
rescue StandardError
  nil
end

cmd = ARGV[0] || 'list'

case cmd
when 'list'
  puts fetch('/names')

when 'preview'
  name = ARGV[1]
  pf = File.join(PREVIEW_DIR, name)
  if File.exist?(pf)
    puts File.read(pf)
  else
    json = fetch("/api/v1/gems/#{name}.json")
    if json
      out = format_preview(json)
      if out
        File.write(pf, out)
        puts out
      end
    end
  end

when 'select'
  name = ARGV[1]
  IO.popen(['wl-copy'], 'w') { |io| io.write(name) }
  spawn('paplay', "#{ENV['SOUND_THEME_PATH']}/completion-partial.oga")

when 'actions'
  puts "Copy name\nOpen on RubyGems\nOpen source"

when 'action'
  action, name = ARGV[1], ARGV[2]
  case action
  when 'Copy name'
    IO.popen(['wl-copy'], 'w') { |io| io.write(name) }
    spawn('paplay', "#{ENV['SOUND_THEME_PATH']}/completion-partial.oga")
  when 'Open on RubyGems'
    system('xdg-open', "https://rubygems.org/gems/#{name}")
  when 'Open source'
    json = fetch("/api/v1/gems/#{name}.json")
    url = json && JSON.parse(json)['source_code_uri']
    if url && !url.empty?
      system('xdg-open', url)
    else
      system('notify-send', 'RubyGems', "No source URL found for #{name}")
    end
  end
end
