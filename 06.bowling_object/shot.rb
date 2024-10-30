# frozen_string_literal: true

class Shot
  attr_reader :pins

  STRIKE_MARK = 'X'
  STRIKE_PINS = 10

  def initialize(score)
    @pins = score == STRIKE_MARK ? STRIKE_PINS : score.to_i
  end
end
