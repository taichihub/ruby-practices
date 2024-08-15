# frozen_string_literal: true

require 'optparse'

def main
  options = parse_options
  if ARGV.empty?
    handle_stdin(options)
  else
    handle_files(ARGV, options)
  end
end

def parse_options
  options = { lines: false, words: false, bytes: false }
  OptionParser.new do |opts|
    opts.banner = 'Usage: wc.rb [options] [file ...]'
    opts.on('-l', 'Count lines') { options[:lines] = true }
    opts.on('-w', 'Count words') { options[:words] = true }
    opts.on('-c', 'Count bytes') { options[:bytes] = true }
  end.parse!
  options.values.any? ? options : options.transform_values { true }
end

def handle_stdin(options)
  file_content = $stdin.read
  counts = count_all(file_content)
  output_results(counts, options)
end

def handle_files(files, options)
  file_counts = files.map { |file| count_file_contents(file) }
  file_counts.each { |file_data| output_results(file_data[:counts], options, file_data[:filename]) }
  output_total(file_counts, options) if files.size > 1
end

def output_total(file_counts, options)
  total_counts = calculate_totals(file_counts.map { |data| data[:counts] })
  output_results(total_counts, options, 'total')
end

def count_file_contents(file)
  file_content = File.read(file)
  { counts: count_all(file_content), filename: file }
end

def calculate_totals(file_counts)
  {
    lines: file_counts.sum { |counts| counts[:lines] },
    words: file_counts.sum { |counts| counts[:words] },
    bytes: file_counts.sum { |counts| counts[:bytes] }
  }
end

def count_all(content)
  lines = content.count("\n")
  words = content.split(/\s+/).reject(&:empty?).count
  bytes = content.bytesize
  { lines: lines, words: words, bytes: bytes }
end

def output_results(counts, options, filename = nil)
  outputs = [format_line_count(counts, options), format_word_count(counts, options), format_byte_count(counts, options)]
  formatted_output = outputs.compact.join('')
  puts formatted_output + format_filename(filename)
end

def format_line_count(counts, options)
  format_count(counts[:lines], 8) if options[:lines] || no_option_selected?(options)
end

def format_word_count(counts, options)
  format_count(counts[:words], 8) if options[:words] || no_option_selected?(options)
end

def format_byte_count(counts, options)
  format_count(counts[:bytes], 8) if options[:bytes] || no_option_selected?(options)
end

def format_count(count, width)
  count.to_s.rjust(width)
end

def format_filename(filename)
  filename ? " #{filename}" : ''
end

def no_option_selected?(options)
  !options[:lines] && !options[:words] && !options[:bytes]
end

main
