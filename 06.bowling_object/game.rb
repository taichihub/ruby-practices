# frozen_string_literal: true

require_relative 'frame'
require_relative 'constants'

class Game
  attr_reader :frames

  def initialize
    @frames = []
  end

  def record_shots(pins)
    pins.each do |pin|
      current_frame.add_shot(pin)
      create_new_frame_if_necessary
    end
  end

  def calculate_game_score
    @frames.each_with_index.sum do |frame, index|
      if index + 1 == FRAMES
        frame.calculate_frame_score(nil, nil, true)
      else
        frame.calculate_frame_score(@frames[index + 1], @frames[index + 2], false)
      end
    end
  end

  private

  def current_frame
    @frames.last || create_new_frame
  end

  def create_new_frame
    new_frame = Frame.new
    @frames << new_frame
    new_frame
  end

  def create_new_frame_if_necessary
    create_new_frame if current_frame.complete?(last_frame?) && !last_frame?
  end

  def last_frame?
    @frames.size == FRAMES
  end
end
