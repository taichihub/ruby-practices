# frozen_string_literal: true

require 'optparse'

def parse_options
  options = { lines: false, words: false, bytes: false }
  OptionParser.new do |opts|
    opts.banner = 'Usage: wc.rb [options] [file ...]'
    opts.on('-l', 'Count lines') { options[:lines] = true }
    opts.on('-w', 'Count words') { options[:words] = true }
    opts.on('-c', 'Count bytes') { options[:bytes] = true }
  end.parse!
  options.transform_values! { |_| true } unless options.values.any?
  options
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

def output_results(counts, options, filename = nil, total: false)
  output = []
  output << format('%8d', counts[:lines]) if options[:lines]
  output << format('%8d', counts[:words]) if options[:words]
  output << format('%8d', counts[:bytes]) if options[:bytes]
  output << " #{filename}" if filename
  output << ' total' if total

  puts output.join(' ')
end

def handle_multiple_files(files, options)
  total_counts = files.map { |file| process_single_file(file, options) }

  return unless files.size > 1

  total_lines, total_words, total_bytes = total_counts.map(&:values).transpose.map(&:sum)
  output_results({ lines: total_lines, words: total_words, bytes: total_bytes }, options, 'total', total: true)
end

def process_single_file(file, options)
  file_content = File.read(file)
  counts = count_all(file_content)
  output_results(counts, options, file)
  counts
end

def count_all(content)
  {
    lines: count_lines(content),
    words: count_words(content),
    bytes: count_bytes(content)
  }
end

def main
  options = parse_options

  if ARGV.empty?
    file_content = $stdin.read
    counts = count_all(file_content)
    output_results(counts, options)
  else
    handle_multiple_files(ARGV, options)
  end
end

main
