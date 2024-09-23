# frozen_string_literal: true

require_relative 'frame'
require_relative 'constants'

class Game
  FRAMES = 10

  def initialize(pins)
    @frames = []
    frames_data = split_pins_into_frames(pins)
    frames_data.each { |frame_pins| @frames << Frame.new(frame_pins) }
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      if index == FRAMES - 1
        frame.score(nil, nil, true)
      else
        frame.score(@frames[index + 1], @frames[index + 2], false)
      end
    end
  end

  private

  def split_pins_into_frames(pins)
    frames = []
    frame = []

    pins.each do |pin|
      frame << pin
      if frames.size < FRAMES - 1 && (frame.sum == MAX_PINS || frame.size == PER_FRAME_MAX_SHOTS)
        frames << frame
        frame = []
      elsif frames.size == FRAMES - 1 && frame.size <= 3
        frames << frame
      end
    end

    frames
  end
end
