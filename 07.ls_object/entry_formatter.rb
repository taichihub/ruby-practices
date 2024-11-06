# frozen_string_literal: true

class EntryFormatter
  def initialize(entries, size_width)
    @entries = entries
    @size_width = size_width
  end

  def self.format(entries, detailed_info, size_width)
    if detailed_info
      entries.map { |entry| entry.detailed_info(size_width) }.join("\n")
    else
      new(entries, size_width).format_grid
    end
  end

  def format_grid
    max_entry_width = @entries.map(&:name).map(&:length).max + 5
    items_per_column = calculate_items_per_column(@entries.size)
    formatted_entries = slice_entries_for_display(@entries.map(&:name), items_per_column)
    build_grid(formatted_entries, max_entry_width)
  end

  private

  def calculate_items_per_column(items)
    (items.to_f / 3).ceil
  end

  def slice_entries_for_display(entries, items_per_column)
    entries.each_slice(items_per_column).to_a
  end

  def build_grid(formatted_entries, max_entry_width)
    safe_transpose(formatted_entries).map do |row|
      row.map { |entry| (entry || '').ljust(max_entry_width) }.join
    end.join("\n")
  end

  def safe_transpose(entries)
    max_length = entries.map(&:size).max
    padded_entries = entries.map { |row| row.dup.fill(nil, row.length...max_length) }
    padded_entries.transpose
  end
end
