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
  file_counts.each { |counts, filename| output_results(counts, options, filename) }
  output_total(file_counts, options) if files.size > 1
end

def output_total(file_counts, options)
  total_counts = calculate_totals(file_counts.map(&:first))
  output_results(total_counts, options, 'total')
end

def count_file_contents(file)
  file_content = File.read(file)
  [count_all(file_content), file]
end

def calculate_totals(file_counts)
  {
    lines: file_counts.sum { |counts| counts[:lines] },
    words: file_counts.sum { |counts| counts[:words] },
    bytes: file_counts.sum { |counts| counts[:bytes] }
  }
end

def count_all(content)
  {
    lines: count_lines(content),
    words: count_words(content),
    bytes: count_bytes(content)
  }
end

def count_lines(content)
  content.count("\n")
end

def count_words(content)
  content.split(/\s+/).reject(&:empty?).count
end

def count_bytes(content)
  content.bytesize
end

def output_results(counts, options, filename = nil)
  output = build_output(counts, options)
  output.unshift('') if prepend_space?(options)
  output << filename unless filename.nil?
  puts output.join(' ')
end

def build_output(counts, options)
  [].tap do |output|
    add_lines_to_output(output, counts, options)
    add_words_to_output(output, counts, options)
    add_bytes_to_output(output, counts, options)
  end
end

def add_lines_to_output(output, counts, options)
  output << format('%8d', counts[:lines]) if options[:lines] || !any_option_selected?(options)
end

def add_words_to_output(output, counts, options)
  output << format_words(counts) if options[:words] || !any_option_selected?(options)
end

def add_bytes_to_output(output, counts, options)
  output << format_bytes(counts) if options[:bytes] || !any_option_selected?(options)
end

def any_option_selected?(options)
  options[:lines] || options[:words] || options[:bytes]
end

def format_words(counts)
  format("%#{8 - counts[:lines].to_s.size}d", counts[:words])
end

def format_bytes(counts)
  case counts[:words].to_s.size
  when 3
    format_adjusted_bytes(10, counts)
  when 2
    format_adjusted_bytes(9, counts)
  when 1
    format_adjusted_bytes(8, counts)
  end
end

def format_adjusted_bytes(number, counts)
  format("%#{number - counts[:words].to_s.size}d", counts[:bytes])
end

def prepend_space?(options)
  word_option?(options) || byte_option?(options) || word_and_byte_option?(options)
end

def word_option?(options)
  options[:words] && !options[:lines] && !options[:bytes]
end

def byte_option?(options)
  options[:bytes] && !options[:lines] && !options[:words]
end

def word_and_byte_option?(options)
  options[:words] && options[:bytes] && !options[:lines]
end

main
