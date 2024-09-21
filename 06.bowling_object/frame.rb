# frozen_string_literal: true

require_relative 'shot'
require_relative 'constants'

class Frame
  attr_reader :shots

  def initialize
    @shots = []
  end

  def add_shot(pins)
    @shots << Shot.new(pins)
  end

  def complete?(is_last_frame)
    if is_last_frame
      @shots.size == (strike? || spare? ? PER_FRAME_MAX_SHOTS + 1 : PER_FRAME_MAX_SHOTS)
    else
      strike? || @shots.size == PER_FRAME_MAX_SHOTS
    end
  end

  def calculate_frame_score(next_frame, next_next_frame, is_last_frame)
    if is_last_frame
      @shots.sum(&:pins)
    elsif strike?
      MAX_PINS + bonus_for_strike(next_frame, next_next_frame)
    elsif spare?
      MAX_PINS + bonus_for_spare(next_frame)
    else
      @shots.sum(&:pins)
    end
  end

  def strike?
    @shots.first.pins == MAX_PINS
  end

  def spare?
    @shots.size == PER_FRAME_MAX_SHOTS && @shots.sum(&:pins) == MAX_PINS
  end

  private

  def bonus_for_strike(next_frame, next_next_frame)
    if next_frame&.strike? && next_next_frame
      MAX_PINS + next_next_frame.shots.first.pins
    elsif next_frame
      next_frame.shots.first(2).sum(&:pins)
    else
      NO_FRAME
    end
  end

  def bonus_for_spare(next_frame)
    next_frame&.shots&.first&.pins || NO_FRAME
  end
end
