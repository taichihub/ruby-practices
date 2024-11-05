# frozen_string_literal: true

require_relative 'file_entry'
require_relative 'entry_formatter'

class DirectoryLister
  def initialize(options)
    @options = options
  end

  def list
    entries = fetch_entries
    sorted_entries = sort_entries(entries)
    puts "total #{total_blocks(sorted_entries)}" if @options.detailed_info
    max_size_length = calculate_max_size_length(sorted_entries)
    formatted_output = EntryFormatter.format(sorted_entries, @options.detailed_info, max_size_length)
    puts formatted_output
  end

  private

  def fetch_entries
    pattern = @options.include_hidden ? ['*', '.*'] : '*'
    Dir.glob(pattern).reject { |entry| ['.', '..'].include?(entry) }.map { |name| FileEntry.new(name) }
  end

  def sort_entries(entries)
    sorted_files = entries.sort_by(&:name)
    @options.reverse_order ? sorted_files.reverse : sorted_files
  end

  def total_blocks(entries)
    entries.sum { |entry| entry.blocks }
  end

  def calculate_max_size_length(entries)
    max_size = entries.map { |entry| entry.size }.max
    max_size.to_s.length + 1
  end
end
