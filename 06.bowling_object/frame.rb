# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots, :index

  MAX_PINS = 10

  def initialize(index)
    @shots = []
    @index = index
  end

  def add_shot(pins)
    @shots << Shot.new(pins)
  end

  def calculate_frame_score(next_frame = nil, next_next_frame = nil)
    return @shots.sum(&:pins) if @index == 9

    if strike?
      return score = MAX_PINS + bonus_for_strike(next_frame, next_next_frame)
    elsif spare?
      score = MAX_PINS + bonus_for_spare(next_frame)
    else
      score = @shots.sum(&:pins)
    end

    score
  end

  def strike?
    @shots.first.pins == MAX_PINS
  end

  def spare?
    @shots.size == 2 && @shots.sum(&:pins) == MAX_PINS
  end

  private

  def bonus_for_strike(next_frame, next_next_frame)
    if next_frame&.strike? && next_next_frame
      next_frame.shots.first.pins + next_next_frame.shots.first.pins
    elsif next_frame
      next_frame.shots.first(2).sum(&:pins)
    else
      0
    end
  end

  def bonus_for_spare(next_frame)
    next_frame&.shots&.first&.pins || 0
  end
end
