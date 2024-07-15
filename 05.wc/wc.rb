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

def output_results(content, options, filename = nil)
  line_count = count_lines(content)
  word_count = count_words(content)
  byte_count = count_bytes(content)

  output = []
  output << format('%8d', line_count) if options[:lines]
  output << format('%8d', word_count) if options[:words]
  output << format('%8d', byte_count) if options[:bytes]
  output << " #{filename}" if filename

  puts output.join(' ')

  [line_count, word_count, byte_count]
end

def process_files(files, options)
  total_counts = files.map { |file| process_single_file(file, options) }

  return unless files.size > 1

  total_lines, total_words, total_bytes = total_counts.transpose.map(&:sum)
  output_total(total_lines, total_words, total_bytes, options)
end

def process_single_file(file, options)
  file_content = File.read(file)
  output_results(file_content, options, file)
end

def output_total(total_lines, total_words, total_bytes, options)
  output = []
  output << format('%8d', total_lines) if options[:lines]
  output << format('%8d', total_words) if options[:words]
  output << format('%8d', total_bytes) if options[:bytes]
  output << ' total'

  puts output.join(' ')
end

def main
  options = parse_options

  if ARGV.empty?
    file_content = $stdin.read
    output_results(file_content, options)
  else
    process_files(ARGV, options)
  end
end

main
