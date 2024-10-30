# frozen_string_literal: true

require_relative 'game'
require_relative 'shot'
require_relative 'constants'

def main
  input = ARGV[0]
  pin_marks = input.split(',')

  shots = pin_marks.map do |mark|
    Shot.new(mark)
  end

  game = Game.new(shots)
  total_score = game.score
  puts total_score
end

main
