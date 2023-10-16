#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  if ARGV.length != 3
    puts 'Usage: ruby playlist_pal.rb <input-file> <changes-file> <output-file>'
    return
  end

  input_file = ARGV[0]
  changes_file = ARGV[1]
  output_file = ARGV[2]

  puts "Input File: #{input_file}"
  puts "Changes File: #{changes_file}"
  puts "Output File: #{output_file}"
end

main if __FILE__ == $PROGRAM_NAME
