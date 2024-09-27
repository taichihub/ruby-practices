# frozen_string_literal: true

require_relative 'frame'
require_relative 'constants'

class Game
  def initialize(pins)
    @frames = []
    frames_data = split_pins_into_frames(pins)
    frames_data.each_with_index.map { |frame_pins, index| @frames << Frame.new(frame_pins, index) }
  end

  def score
    @frames.each_with_index.sum do |frame, index|
      frame.score(*@frames[(index + 1)..(index + 2)])
    end
  end

  private

  def split_pins_into_frames(pins)
    frames = []
    frame = []

    pins.each do |pin|
      frame << pin
      if frame_complete?(frames, frame)
        frames << frame
        frame = []
      end
    end

    frames << frame if !frame.empty?
    frames
  end

  def frame_complete?(frames, frame)
    if frames.size == FRAMES - 1
      frame.size == PER_FRAME_MAX_SHOTS + 1
    else
      frame.sum(&:pins) == MAX_PINS || frame.size == PER_FRAME_MAX_SHOTS
    end
  end
end
