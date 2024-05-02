# frozen_string_literal: true

require 'etc'

COLUMNS = 3
BLANK_SIZE = 8

def fetch_entries(include_hidden: false)
  pattern = include_hidden ? ['*', '.*'] : '*'
  Dir.glob(pattern).reject { |entry| ['.', '..'].include?(entry) }
end

def dictionary_sort(files)
  files.sort
end

def calculate_items_per_column(items)
  (items.to_f / COLUMNS).ceil
end

def slice_entries_for_display(entries, items_per_column)
  entries.each_slice(items_per_column).to_a
end

def calculate_max_widths(formatted_entries)
  formatted_entries.map do |col|
    col.map(&:length).max
  end
end

def safe_transpose(entries)
  max_length = entries.map(&:size).max
  padded_entries = entries.map do |row|
    row.dup.fill(nil, row.length...max_length)
  end
  padded_entries.transpose
end

def print_entries(formatted_entries, max_widths)
  safe_transpose(formatted_entries).each do |row|
    row.each_with_index do |entry, index|
      print (entry || '').ljust(max_widths[index] + BLANK_SIZE)
    end
    puts
  end
end

def format_files_detail(entry)
  stat = File.stat(entry)
  ftype = case stat.ftype
          when 'directory' then 'd'
          when 'file' then '-'
          else '?'
          end
  permissions = format('%o', stat.mode)[-3, 3].chars.map { |ch| ch.to_i.to_s(2).rjust(3, '0') }.join.tr('1', 'r').tr('0', '-')
  nlink = stat.nlink
  owner = Etc.getpwuid(stat.uid).name
  group = Etc.getgrgid(stat.gid).name
  size = stat.size
  mtime = stat.mtime.strftime('%b %e %H:%M')
  "#{ftype}#{permissions} #{nlink} #{owner} #{group} #{size} #{mtime} #{entry}"
end

def format_file_detail(entries)
  entries.map { |entry| format_files_detail(entry) }
end

def main
  include_hidden = ARGV.include?('-a')
  entries = fetch_entries(include_hidden:)
  reverse_order = ARGV.include?('-r')
  display_detailed_file_information = ARGV.include?('-l')
  sorted_entries = dictionary_sort(entries)
  sorted_entries.reverse! if reverse_order

  if display_detailed_file_information
    formatted_entries = get_file_detail(sorted_entries)
    puts formatted_entries
  else
    items_per_column = calculate_items_per_column(sorted_entries.size)
    formatted_entries = slice_entries_for_display(sorted_entries, items_per_column)
    max_widths = calculate_max_widths(formatted_entries)
    print_entries(formatted_entries, max_widths)
  end
end

main if __FILE__ == $PROGRAM_NAME
