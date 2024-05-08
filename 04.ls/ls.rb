# frozen_string_literal: true

require 'etc'

COLUMNS = 3
BLANK_SIZE = 8

def parse_options(args)
  options = {
    include_hidden: false,
    reverse_order: false,
    detailed_info: false
  }
  args.each do |arg|
    next unless arg.start_with?('-')
    arg[1..-1].chars.each do |option|
      case option
      when 'a'
        options[:include_hidden] = true
      when 'r'
        options[:reverse_order] = true
      when 'l'
        options[:detailed_info] = true
      else
        raise ArgumentError, "無効なオプション: #{option}"
      end
    end
  end
  options
end

def fetch_entries(include_hidden: false)
  pattern = include_hidden ? ['*', '.*'] : '*'
  Dir.glob(pattern).reject { |entry| ['.', '..'].include?(entry) }
end

def dictionary_sort(files, reverse_order: false)
  sorted_files = files.sort
  reverse_order ? sorted_files.reverse : sorted_files
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

def format_file_detail(entry)
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

def format_file_details(entries)
  entries.map { |entry| format_file_detail(entry) }
end

def main
  options = parse_options(ARGV)
  entries = fetch_entries(include_hidden: options[:include_hidden])
  sorted_entries = dictionary_sort(entries, reverse_order: options[:reverse_order])

  if options[:detailed_info]
    formatted_entries = format_file_details(sorted_entries)
    puts formatted_entries
  else
    items_per_column = calculate_items_per_column(sorted_entries.size)
    formatted_entries = slice_entries_for_display(sorted_entries, items_per_column)
    max_widths = calculate_max_widths(formatted_entries)
    print_entries(formatted_entries, max_widths)
  end
end

main if __FILE__ == $PROGRAM_NAME
