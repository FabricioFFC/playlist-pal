# frozen_string_literal: true

require_relative '../playlist_pal'

describe 'PlaylistPal' do
  context 'when input is valid' do
    before do
      allow(ARGV).to receive(:length).and_return(3)
      allow(ARGV).to receive(:[]).with(0).and_return('sample-data/spotify.json')
      allow(ARGV).to receive(:[]).with(1).and_return('sample-data/changes.json')
      allow(ARGV).to receive(:[]).with(2).and_return(output_filename)
    end

    let(:output_filename) { 'output.json' }
    let(:expected_output_file) { JSON.parse(File.read('spec/fixtures/expected_output.json')) }
    let(:output_file) { JSON.parse(File.read(output_filename)) }

    after { File.delete(output_filename) if File.exist?(output_filename) }

    it 'prints success messages and generates output file with changes' do
      expect { main }.to output("Playlist updated successfully!\nOutput file: output.json\n").to_stdout
      expect(output_file).to eql(expected_output_file)
    end
  end

  context 'when input is invalid' do
    it 'prints correct usage' do
      expect { main }.to output(/Usage: ruby playlist_pal.rb <input-file> <changes-file> <output-file>\n/).to_stdout
    end
  end
end
