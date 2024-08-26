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
  content = $stdin.read
  file_info = { counts: count_all(content) }
  output_results(file_info, options)
end

def handle_files(files, options)
  counts = files.map do |file|
    content = File.read(file)
    { counts: count_all(content), filename: file }
  end
  counts.each { |file_info| output_results(file_info, options) }
  output_total(counts, options) if files.size > 1
end

def output_total(counts, options)
  total_counts = calculate_totals(counts)
  file_info = { counts: total_counts, filename: 'total' }
  output_results(file_info, options)
end

def calculate_totals(counts)
  total_counts = { lines: 0, words: 0, bytes: 0 }
  counts.each do |data|
    total_counts[:lines] += data[:counts][:lines]
    total_counts[:words] += data[:counts][:words]
    total_counts[:bytes] += data[:counts][:bytes]
  end
  total_counts
end

def count_all(content)
  {
    lines: content.count("\n"),
    words: content.split(/\s+/).reject(&:empty?).count,
    bytes: content.bytesize
  }
end

def output_results(file_info, options)
  outputs = file_info[:counts].keys.filter_map do |key|
    file_info[:counts][key].to_s.rjust(8) if options[key] || options.values.none?
  end
  outputs << " #{file_info[:filename]}" if file_info[:filename]
  puts outputs.join
end

main
