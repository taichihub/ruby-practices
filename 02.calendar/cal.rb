#!/usr/bin/env ruby

require 'date' 
require 'optparse' 

def parse_arguments
  options = {}
  OptionParser.new do |opts|
    opts.on("-y YEAR") do |year|
      options[:year] = year.to_i
    end
    opts.on("-m MONTH") do |month|
      options[:month] = month.to_i
    end
  end.parse! 
  options 
end

def print_calendar(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)

  puts first_date.strftime("%-m月 %Y").center(20)
  puts "日 月 火 水 木 金 土"
  print "   " * first_date.wday 

  (first_date..last_date).each do |date|
    if date.saturday?
      print date.day.to_s.rjust(2) + "\n"
    else
      print date.day.to_s.rjust(2) + " "
    end
  end
  print "\n" unless last_date.saturday?
end

def valid_date?(year, month)
  year.is_a?(Integer) && year > 0 && month.is_a?(Integer) && month.between?(1, 12)
end

def main
  options = parse_arguments
  year = options[:year] || Date.today.year
  month = options[:month] || Date.today.month

  if valid_date?(year, month)
    print_calendar(year, month)
  else
    puts "無効な日付が指定されました"
  end
end

main if __FILE__ == $0
