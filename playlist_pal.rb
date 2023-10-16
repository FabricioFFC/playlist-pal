#!/usr/bin/env ruby
# frozen_string_literal: true

require 'playlist_updater'

def print_result(result)
  if result.success?
    puts 'Playlist updated successfully!'
    puts "Output file: #{ARGV[2]}"
  else
    puts result.error
  end
end

def main
  if ARGV.length != 3
    puts 'Usage: ruby playlist_pal.rb <input-file> <changes-file> <output-file>'
    return
  end

  result = PlaylistUpdater.new(ARGV[0], ARGV[1], ARGV[2]).call

  print_result(result)
end

main if __FILE__ == $PROGRAM_NAME
