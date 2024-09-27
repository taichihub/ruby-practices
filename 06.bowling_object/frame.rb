# frozen_string_literal: true

require_relative 'shot'
require_relative 'constants'

class Frame
  attr_reader :shots

  NO_FRAME = 0

  def initialize(shots, index)
    @shots = shots
    @index = index
  end

  def score(next_frame = nil, next_next_frame = nil)
    total_pins = @shots.sum(&:pins)
    if last_frame?
      total_pins
    elsif strike?
      total_pins + bonus_for_strike(next_frame, next_next_frame)
    elsif spare?
      total_pins + bonus_for_spare(next_frame)
    else
      total_pins
    end
  end

  def strike?
    @shots.first.pins == MAX_PINS
  end

  def spare?
    @shots.size == PER_FRAME_MAX_SHOTS && @shots.sum(&:pins) == MAX_PINS
  end

  private

  def last_frame?
    @index == FRAMES - 1
  end

  def bonus_for_strike(next_frame = nil, next_next_frame = nil)
    if next_frame&.strike? && next_next_frame
      MAX_PINS + next_next_frame.shots.first.pins
    elsif next_frame
      next_frame.shots.first(2).sum(&:pins)
    else
      NO_FRAME
    end
  end

  def bonus_for_spare(next_frame = nil)
    next_frame&.shots&.first&.pins || NO_FRAME
  end
end
