# frozen_string_literal: true

require 'json'

# This class is responsible for updating a playlist based on a changes file
# rubocop:disable Metrics/ClassLength
class PlaylistUpdater
  Result = Struct.new(:success?, :error)

  def initialize(input_file, changes_file, output_filename)
    @input_file = input_file
    @changes_file = changes_file
    @output_filename = output_filename
  end

  def call
    validate_files_format
    update_playlist
    create_output_file

    Result.new(true)
  rescue StandardError => e
    Result.new(false, e.message)
  end

  private

  def validate_files_format
    validate_input_file
    validate_changes_file
  end

  def validate_input_file
    errors = []

    %w[playlists songs users].each do |key|
      errors << "Input file is missing a `#{key}` key" unless input[key].is_a?(Array)
    end

    raise "Input file has errors: #{errors.join(', ')}" unless errors.empty?
  end

  def validate_changes_file
    if changes_without_operations?
      raise 'Change file has error: it must have at least one of the following keys: `add_song_to_playst`, '\
                '`add_playlist_to_user`, `remove_playlist`'
    end

    return unless change_file_add_playlist_to_user_is_invalid?(changes['add_playlist_to_user'])

    raise 'Change file has error: it must have at least one song id in `add_playlist_to_user`'
  end

  def changes_without_operations?
    [changes['add_song_to_playlist'], changes['add_playlist_to_user'],
     changes['remove_playlist']].all?(&:nil?)
  end

  def change_file_add_playlist_to_user_is_invalid?(operation)
    !operation.nil? && operation['song_ids'].is_a?(Array) &&
      operation['song_ids'].none?
  end

  def input
    @input ||= read_file(@input_file)
  end

  def changes
    @changes ||= read_file(@changes_file)
  end

  def read_file(file_path)
    json_file = File.read(relative_file_path(file_path))
    JSON.parse(json_file)
  rescue JSON::ParserError
    raise 'Input file is not a valid JSON'
  end

  def relative_file_path(file_path)
    File.join(File.expand_path('..', __dir__), file_path)
  end

  def update_playlist
    add_song_to_playlist unless changes['add_song_to_playlist'].nil?
    add_playlist_to_user unless changes['add_playlist_to_user'].nil?
    remove_playlist unless changes['remove_playlist'].nil?
  end

  def add_song_to_playlist
    playlist_id = changes['add_song_to_playlist']['playlist_id'].to_s
    song_id = changes['add_song_to_playlist']['song_id'].to_s

    input['playlists'].each do |playlist|
      next unless playlist['id'].to_s == playlist_id

      playlist['song_ids'] << song_id
      break
    end
  end

  # rubocop:disable Metrics/AbcSize
  def add_playlist_to_user
    user_id = changes['add_playlist_to_user']['user_id'].to_s
    song_ids = changes['add_playlist_to_user']['song_ids'].map(&:to_s)

    input['users'].each do |user|
      next unless user['id'].to_s == user_id

      input['playlists'] << create_playlist(user_id, song_ids)

      break
    end
  end
  # rubocop:enable Metrics/AbcSize

  def remove_playlist
    playlist_id = changes['remove_playlist']['playlist_id'].to_s

    input['playlists'].each do |playlist|
      next unless playlist['id'].to_s == playlist_id

      input['playlists'].delete(playlist)
      break
    end
  end

  def create_playlist(user_id, song_ids)
    {
      'id' => increment_playlist_id.to_s,
      'owner_id' => user_id,
      'song_ids' => song_ids
    }
  end

  def increment_playlist_id
    @increment_playlist_id = last_playlist_id
    @increment_playlist_id += 1
  end

  def last_playlist_id
    @last_playlist_id ||= input['playlists'].map { |playlist| playlist['id'].to_i }.max
  end

  def create_output_file
    File.open(relative_file_path(@output_filename), 'w') do |f|
      f.write(JSON.generate(input))
    end
  end
end
# rubocop:enable Metrics/ClassLength
