# frozen_string_literal: true

require 'etc'

class FileEntry
  attr_reader :name

  def initialize(name)
    @name = name
    @stat = File.stat(name)
  end

  def detailed_info(size_width)
    ftype = file_type
    permissions = format_permissions
    nlink = @stat.nlink
    owner = Etc.getpwuid(@stat.uid).name
    group = Etc.getgrgid(@stat.gid).name
    size = @stat.size.to_s.rjust(size_width)
    mtime = format_mtime
    "#{ftype}#{permissions}  #{nlink} #{owner}  #{group} #{size} #{mtime} #{@name}"
  end

  def blocks
    @stat.blocks
  end

  def size
    @stat.size
  end

  private

  def format_permissions
    modes = {
      0 => "---", 1 => "--x", 2 => "-w-", 3 => "-wx",
      4 => "r--", 5 => "r-x", 6 => "rw-", 7 => "rwx"
    }
    octal_mode = format('%o', @stat.mode)[-3, 3]
    octal_mode.chars.map { |n| modes[n.to_i] }.join
  end

  def file_type
    case @stat.ftype
    when 'directory' then 'd'
    when 'file' then '-'
    else '?'
    end
  end

  def format_mtime
    month_format = @stat.mtime.strftime('%-m').to_i < 10 ? ' %-m %e' : '%m %e'
    six_months_ago = @stat.mtime < Time.now - (6 * 30 * 24 * 60 * 60)
    date_format = six_months_ago ? "#{month_format}  %Y" : "#{month_format} %H:%M"
    @stat.mtime.strftime(date_format)
  end
end
