# frozen_string_literal: true

require_relative 'game'

def main
  input_scores = ARGV[0].split(',').map do |score|
    Shot.new(score).pins
  end
  game = Game.new(input_scores)
  total_score = game.score
  puts total_score
end

main
