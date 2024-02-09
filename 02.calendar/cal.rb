#!/usr/bin/env ruby

require 'date' # Dateクラスを使うため
require 'optparse' # コマンドライン引数をパースするため

# コマンドライン引数をパース
def parse_arguments
  options = {}
  OptionParser.new do |opts|
    opts.on("-y YEAR") do |year|
      options[:year] = year.to_i
    end
    opts.on("-m MONTH") do |month|
      options[:month] = month.to_i
    end
  end.parse! # ARGV削除
  options # ハッシュで返す
end

# カレンダー表示
def print_calendar(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)

  puts first_day.strftime("%-m月 %Y").center(20)
  puts "日 月 火 水 木 金 土"
  print "   " * first_day.wday # 1日までの空白を出力

  (first_day..last_day).each do |date|
    print date.day.to_s.rjust(2) + " "
    print "\n" if date.saturday? # 土曜日の場合は改行
  end
  print "\n" unless last_day.saturday? # 最終日が土曜日じゃない場合は改行
end

# メイン処理
def main
  options = parse_arguments
  year = options[:year] || Date.today.year
  month = options[:month] || Date.today.month

  begin
    print_calendar(year, month)
  rescue ArgumentError
    puts "無効な日付が指定されました"
  end
end

# コマンドラインから実行された場合のみ動作
main if __FILE__ == $0
