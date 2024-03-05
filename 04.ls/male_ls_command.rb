# frozen_string_literal: true

COLUMNS = 3

SPACES = 8

class Array
  def sefe_transpose
    max_length = map(&:length).max
    map do |row|
      row.dup.fill(nil, row.length...max_length)
    end.transpose
  end
end

def fetch_entries
  
  Dir.glob('*')
end

def natural_sort(files)
  files.sort_by do |file|
    file.split(/(\d+)/).map { |e| e.match?(/\d+/) ? e.to_i : e }
  end
end

def calculate_items_per_column(total_items)
  (total_items.to_f / COLUMNS).ceil
end

def slice_entries_for_display(entries, items_per_column)
  entries.each_slice(items_per_column).to_a
end

def calculate_max_widths(formatted_entries)
  formatted_entries.map do |col|
    col.map(&:length).max
  end
end

def print_entries(formatted_entries, max_widths)
  formatted_entries.sefe_transpose.each do |row|
    row.each_with_index do |entry, index|
      print (entry || '').ljust(max_widths[index] + SPACES)
    end
    puts
  end
end

def main
  entries = fetch_entries
  sorted_entries = natural_sort(entries)
  items_per_column = calculate_items_per_column(sorted_entries.size)
  formatted_entries = slice_entries_for_display(sorted_entries, items_per_column)
  max_widths = calculate_max_widths(formatted_entries)
  print_entries(formatted_entries, max_widths)
end

main if __FILE__ == $0
