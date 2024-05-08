# frozen_string_literal: true

def count_data(input)
  lines = input.split("\n")
  words = input.split
  bytes = input.bytesize
  [lines.count, words.count, bytes]
end

def print_counts(counts, label = nil)
  label_part = label ? " #{label}" : ''
  puts "#{counts[0].to_s.rjust(8)} #{counts[1].to_s.rjust(8)} #{counts[2].to_s.rjust(8)}#{label_part}"
end

args = ARGV.dup

options = {
  lines: args.any? { |arg| ['-l', '-lwc', '-lc', '-lw'].include?(arg) },
  words: args.any? { |arg| ['-w', '-lwc', '-wc', '-lw'].include?(arg) },
  bytes: args.any? { |arg| ['-c', '-lwc', '-wc', '-lc'].include?(arg) }
}

options = { lines: true, words: true, bytes: true } if options.values.none?

args.reject! { |arg| arg.start_with?('-') }

total_counts = [0, 0, 0]

if args.empty?
  input = $stdin.read
  counts = count_data(input)
  print_counts(counts) if input.length.positive?
else
  args.each do |filename|
    if File.exist?(filename)
      input = File.read(filename)
      counts = count_data(input)
      print_counts(counts, filename)
      total_counts = total_counts.zip(counts).map(&:sum)
    else
      puts "wc: #{filename}: ファイルが見つかりません"
    end
  end
  print_counts(total_counts, '合計') if args.length > 1
end
