# frozen_string_literal: true

class OptionParser
  attr_reader :include_hidden, :reverse_order, :detailed_info

  def initialize(args)
    @include_hidden = false
    @reverse_order = false
    @detailed_info = false
    parse(args)
  end

  private

  def parse(args)
    args.each do |arg|
      next unless arg.start_with?('-')

      arg[1..].chars.each do |option|
        case option
        when 'a'
          @include_hidden = true
        when 'r'
          @reverse_order = true
        when 'l'
          @detailed_info = true
        end
      end
    end
  end
end
