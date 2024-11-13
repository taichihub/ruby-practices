# frozen_string_literal: true

require 'etc'

class FileEntry
  attr_reader :name, :stat

  def initialize(name)
    @name = name
    @stat = File.stat(name)
  end

  def detailed_info(size_width)
    ftype = file_type
    permissions = format('%o', @stat.mode)[-3, 3].chars.map { |ch| ch.to_i.to_s(2).rjust(3, '0') }.join.tr('1', 'r').tr('0', '-')
    nlink = @stat.nlink
    owner = Etc.getpwuid(@stat.uid).name
    group = Etc.getgrgid(@stat.gid).name
    size = @stat.size.to_s.rjust(size_width)
    mtime = format_mtime(@stat.mtime)
    "#{ftype}#{permissions}  #{nlink} #{owner}  #{group} #{size} #{mtime} #{@name}"
  end

  private

  def file_type
    case @stat.ftype
    when 'directory' then 'd'
    when 'file' then '-'
    else '?'
    end
  end

  def format_mtime(mtime)
    month_format = mtime.strftime('%-m').to_i < 10 ? ' %-m %e' : '%m %e'
    six_months_ago = mtime < Time.now - (6 * 30 * 24 * 60 * 60)
    date_format = six_months_ago ? "#{month_format}  %Y" : "#{month_format} %H:%M"
    mtime.strftime(date_format)
  end
end
