# frozen_string_literal: true

require 'optparse'

# 行数をカウントする関数
def count_lines(content)
  return 0 if content.empty?

  lines = content.count("\n")
  lines += 1 unless content.end_with?("\n") # 最後に改行がなければ1行追加
  lines
end

# 単語数をカウントする関数
def count_words(content)
  words = content.split(/\s+/).reject(&:empty?)
  words.count
end

# バイト数をカウントする関数
def count_bytes(content)
  content.bytesize
end

# オプションの解析
options = { lines: false, words: false, bytes: false }
OptionParser.new do |opts|
  opts.banner = 'Usage: wc.rb [options]'
  opts.on('-l', 'Count lines') { options[:lines] = true }
  opts.on('-w', 'Count words') { options[:words] = true }
  opts.on('-c', 'Count bytes') { options[:bytes] = true }
end.parse!

# オプションが指定されていない場合、すべてのオプションを有効にする
options[:lines] = options[:words] = options[:bytes] = true unless options.values.any?

# 標準入力またはファイルからのデータを読み込み
file_content = ARGF.read

# カウント機能の実行
line_count = count_lines(file_content) if options[:lines]
word_count = count_words(file_content) if options[:words]
byte_count = count_bytes(file_content) if options[:bytes]

# オプションによる出力制御
output = []
output << format('%8d', line_count) if options[:lines]
output << format('%8d', word_count) if options[:words]
output << format('%8d', byte_count) if options[:bytes]

# 出力をスペース区切りで表示
puts output.join(' ')
