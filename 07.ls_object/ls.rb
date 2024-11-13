# frozen_string_literal: true

require_relative 'parsed_options'
require_relative 'directory_lister'

if __FILE__ == $PROGRAM_NAME
  parsed_options = ParsedOptions.new(ARGV)
  DirectoryLister.new(parsed_options).list
end
