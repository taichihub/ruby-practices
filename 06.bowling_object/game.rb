# frozen_string_literal: true

require_relative 'frame'

class Game
  FRAMES = 10

  def initialize(pins)
    frames_data = split_pins_into_frames(pins)
    @frames = frames_data.each_with_index.map { |frame_pins, index| Frame.new(frame_pins, index) }
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
      next if frames.size == FRAMES - 1

      if frame.sum(&:pins) == MAX_PINS || frame.size == PER_FRAME_MAX_SHOTS
        frames << frame
        frame = []
      end
    end

    frames << frame if !frame.empty?
    frames
  end
end
