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
  output_counts_hash = { counts: counts }
  output_results(output_counts_hash, options)
end

def handle_files(files, options)
  file_counts = files.map { |file| count_file_contents(file) }
  file_counts.each { |file_data| output_results(file_data, options) }
  output_total(file_counts, options) if files.size > 1
end

def output_total(file_counts, options)
  total_counts = calculate_totals(file_counts)
  output_content_hash = { counts: total_counts, filename: 'total' }
  output_results(output_content_hash, options)
end

def count_file_contents(file)
  file_content = File.read(file)
  counts = count_all(file_content)
  { counts: counts, filename: file }
end

def calculate_totals(file_data)
  counts = file_data.map { |data| data[:counts] }
  {
    lines: counts.sum { |count| count[:lines] },
    words: counts.sum { |count| count[:words] },
    bytes: counts.sum { |count| count[:bytes] }
  }
end

def count_all(content)
  {
    lines: content.count("\n"),
    words: content.split(/\s+/).reject(&:empty?).count,
    bytes: content.bytesize
  }
end

def output_count_values(file_info, options)
  outputs = []
  no_options = options.values.none?
  %i[lines words bytes].each do |key|
    outputs << format_count(file_info[:counts][key]) if options[key] || no_options
  end
  outputs
end

def output_results(file_info, options)
  outputs = output_count_values(file_info, options)
  formatted_output = outputs.join('')
  filename_output = file_info[:filename] ? " #{file_info[:filename]}" : ''
  puts formatted_output + filename_output
end

def format_count(count)
  count.to_s.rjust(8)
end

main
