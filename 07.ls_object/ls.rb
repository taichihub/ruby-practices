# frozen_string_literal: true

require_relative 'option_parser'
require_relative 'directory_lister'

if __FILE__ == $PROGRAM_NAME
  options = OptionParser.new(ARGV)
  DirectoryLister.new(options).list
end
