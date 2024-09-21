# frozen_string_literal: true

require_relative 'game'

def main
  input_scores = ARGV[0].split(',').map { |score| score == STRIKE_MARK ? MAX_PINS : score.to_i }
  game = Game.new
  game.record_shots(input_scores)
  total_score = game.calculate_game_score
  puts total_score
end

main

TODO: "クラス図修正"
TODO: "プラクティスの例通り実行されるか検証"
TODO: "PR再提出"
