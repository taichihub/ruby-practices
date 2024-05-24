# frozen_string_literal: true

require 'optparse'

# 行数をカウントする関数
def count_lines(content)
  content.lines.count
end

# 単語数をカウントする関数（1文字=1単語）
def count_words(content)
  content.each_char.count { |char| char =~ /\S/ }
end

# バイト数をカウントする関数
def count_bytes(content)
  content.bytesize
end

# オプションの解析
options = { lines: false, words: false, bytes: false }
OptionParser.new do |opts|
  opts.banner = 'Usage: wc.rb [options] [file]'

  opts.on('-l', 'Count lines') { options[:lines] = true }
  opts.on('-w', 'Count words') { options[:words] = true }
  opts.on('-c', 'Count bytes') { options[:bytes] = true }
end.parse!

# オプションが指定されていない場合、すべてのオプションを有効にする
options[:lines] = options[:words] = options[:bytes] = true unless options.values.any?

# ファイルを読み込み
file_content = ARGF.read

# カウント機能の実行
line_count = count_lines(file_content)
word_count = count_words(file_content)
byte_count = count_bytes(file_content)

# オプションによる出力制御
output = []
output << line_count if options[:lines]
output << word_count if options[:words]
output << byte_count if options[:bytes]

# 出力をスペース区切りで表示
puts output.join(' ')
