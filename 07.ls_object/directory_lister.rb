# frozen_string_literal: true

require_relative 'file_entry'
require_relative 'entry_formatter'

class DirectoryLister
  def initialize(options)
    @options = options
  end

  def list
    sorted_entries = sort_entries(fetch_entries)
    max_size_length = sorted_entries.map { |entry| entry.instance_variable_get(:@stat).size }.max.to_s.length + 1
    puts "total #{sorted_entries.sum { |entry| entry.instance_variable_get(:@stat).blocks }}" if @options.detailed_info
    puts EntryFormatter.format(sorted_entries, @options.detailed_info, max_size_length)
  end

  private

  def fetch_entries
    pattern = @options.include_hidden ? ['*', '.*'] : '*'
    Dir.glob(pattern).reject { |entry| ['.'].include?(entry) }.map { |name| FileEntry.new(name) }
  end

  def sort_entries(entries)
    sorted_files = entries.sort_by(&:name)
    @options.reverse_order ? sorted_files.reverse : sorted_files
  end
end
