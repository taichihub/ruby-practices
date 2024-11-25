# frozen_string_literal: true

require_relative 'parsed_options'
require_relative 'directory_lister'

parsed_options = ParsedOptions.new(ARGV)
DirectoryLister.new(parsed_options).list
