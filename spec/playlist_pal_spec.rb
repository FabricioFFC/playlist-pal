# frozen_string_literal: true

require_relative '../playlist_pal'

describe 'PlaylistPal' do
  it 'displays the correct input, changes, and output files' do
    allow(ARGV).to receive(:length).and_return(3)
    allow(ARGV).to receive(:[]).with(0).and_return('arg1_value')
    allow(ARGV).to receive(:[]).with(1).and_return('arg2_value')
    allow(ARGV).to receive(:[]).with(2).and_return('arg3_value')

    expect { main }.to output(/Input File: .+\nChanges File: .+\nOutput File: .+\n/).to_stdout
  end

  it 'handles incorrect usage' do
    expect { main }.to output(/Usage: ruby playlist_pal.rb <input-file> <changes-file> <output-file>\n/).to_stdout
  end
end
