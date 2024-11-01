# frozen_string_literal: true

class EntryFormatter
  COLUMNS = 3
  BLANK_SIZE = 8

  def initialize(entries)
    @entries = entries.map(&:name)
  end

  def self.format(entries, detailed_info)
    if detailed_info
      entries.map(&:detailed_info).join("\n")
    else
      new(entries).format_grid
    end
  end

  def format_grid
    items_per_column = calculate_items_per_column(@entries.size)
    formatted_entries = slice_entries_for_display(@entries, items_per_column)
    max_widths = calculate_max_widths(formatted_entries)
    build_grid(formatted_entries, max_widths)
  end

  private

  def calculate_items_per_column(items)
    (items.to_f / COLUMNS).ceil
  end

  def slice_entries_for_display(entries, items_per_column)
    entries.each_slice(items_per_column).to_a
  end

  def calculate_max_widths(formatted_entries)
    formatted_entries.map { |col| col.map(&:length).max }
  end

  def build_grid(formatted_entries, max_widths)
    safe_transpose(formatted_entries).map do |row|
      row.each_with_index.map { |entry, index| (entry || '').ljust(max_widths[index] + BLANK_SIZE) }.join
    end.join("\n")
  end

  def safe_transpose(entries)
    max_length = entries.map(&:size).max
    padded_entries = entries.map { |row| row.dup.fill(nil, row.length...max_length) }
    padded_entries.transpose
  end
end
