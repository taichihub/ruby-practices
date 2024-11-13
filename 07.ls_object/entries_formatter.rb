# frozen_string_literal: true

class EntriesFormatter
  def initialize(entries, size_width)
    @entries = entries
    @size_width = size_width
  end

  def self.format(entries, detailed_info, size_width)
    detailed_info ? entries.map { |entry| entry.detailed_info(size_width) }.join("\n") : new(entries, size_width).format_grid
  end

  def format_grid
    max_entry_width = @entries.map(&:name).map(&:length).max + 5
    items_per_column = (@entries.size.to_f / 3).ceil
    formatted_entries = @entries.map(&:name).each_slice(items_per_column).to_a
    safe_transpose(formatted_entries).map { |row| row.map { |entry| (entry || '').ljust(max_entry_width) }.join }.join("\n")
  end

  private

  def safe_transpose(entries)
    max_length = entries.map(&:size).max
    entries.map { |row| row.dup.fill(nil, row.length...max_length) }.transpose
  end
end
