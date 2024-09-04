# frozen_string_literal: true

require_relative 'game'

def main
  game = Game.new
  puts '投球結果を入力してください'

  input_scores = gets.chomp.split(',').map(&:to_i)

  input_scores.each do |pins|
    game.record_shot(pins)
  end

  total_score = game.calculate_game_score
  puts "スコア: #{total_score}"
end

main
