# frozen_string_literal: true

require_relative 'frame'

class Game
  attr_reader :frames

  def initialize
    @frames = []
    @current_frame_index = 0
  end

  def record_shot(pins)
    current_frame.add_shot(pins)
    @current_frame_index += 1 if (pins == 10 || current_frame.shots.length == 2) && @current_frame_index != 9
  end

  def current_frame
    @frames[@current_frame_index] ||= Frame.new(@current_frame_index)
  end

  def calculate_game_score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.calculate_frame_score(@frames[index + 1], @frames[index + 2])
      puts "フレーム#{index + 1}: #{total_score}"
    end
    total_score
  end
end
