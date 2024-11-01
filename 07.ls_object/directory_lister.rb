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
    formatted_output = EntryFormatter.format(sorted_entries, @options.detailed_info)
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
end
