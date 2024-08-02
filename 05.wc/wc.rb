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
  max_widths = calculate_max_widths([counts])
  output_results(counts, options, nil, max_widths)
end

def handle_files(files, options)
  file_counts = files.map { |file| count_file_contents(file) }
  max_widths = calculate_max_widths(file_counts.map(&:first))

  file_counts.each do |counts, filename|
    output_results(counts, options, filename, max_widths)
  end

  return unless files.size > 1

  total_counts = calculate_totals(file_counts.map(&:first))
  output_results(total_counts, options, 'total', max_widths)
end

def count_file_contents(file)
  file_content = File.read(file)
  counts = count_all(file_content)
  [counts, file]
end

def calculate_totals(file_counts)
  {
    lines: file_counts.sum { |counts| counts[:lines] },
    words: file_counts.sum { |counts| counts[:words] },
    bytes: file_counts.sum { |counts| counts[:bytes] }
  }
end

def calculate_max_widths(counts_list)
  max_lines = counts_list.map { |counts| counts[:lines].to_s.size }.max
  max_words = counts_list.map { |counts| counts[:words].to_s.size }.max
  max_bytes = counts_list.map { |counts| counts[:bytes].to_s.size }.max
  [max_lines, max_words, max_bytes].map { |w| [w, 6].max }
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

def output_results(counts, options, filename = nil, max_widths = [6, 6, 6])
  output = []
  output << format(" %#{max_widths[0]}d", counts[:lines]) if options[:lines] || !any_option_selected?(options)
  output << format(" %#{max_widths[1]}d", counts[:words]) if options[:words] || !any_option_selected?(options)
  output << format(" %#{max_widths[2]}d", counts[:bytes]) if options[:bytes] || !any_option_selected?(options)
  output << filename unless filename.nil?
  puts output.join(' ')
end

def any_option_selected?(options)
  options[:lines] || options[:words] || options[:bytes]
end

main
