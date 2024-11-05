# frozen_string_literal: true

require 'etc'

class FileEntry
  attr_reader :name

  def initialize(name)
    @name = name
    @stat = File.stat(name)
  end

  def detailed_info
    ftype = file_type
    permissions = formatted_permissions
    nlink = @stat.nlink
    owner = Etc.getpwuid(@stat.uid).name
    group = Etc.getgrgid(@stat.gid).name
    size = @stat.size
    mtime = @stat.mtime.strftime('%m %e %H:%M')
    "#{ftype}#{permissions}  #{nlink} #{owner}  #{group} #{size} #{mtime} #{@name}"
  end

  def blocks
    @stat.blocks
  end

  def size
    @stat.size
  end

  private

  def file_type
    case @stat.ftype
    when 'directory' then 'd'
    when 'file' then '-'
    else '?'
    end
  end

  def formatted_permissions
    format('%o', @stat.mode)[-3, 3].chars.map { |ch| ch.to_i.to_s(2).rjust(3, '0') }.join.tr('1', 'r').tr('0', '-')
  end
end
