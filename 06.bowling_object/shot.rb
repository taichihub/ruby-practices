# frozen_string_literal: true

class Shot
  attr_reader :pins

  STRIKE_MARK = 'X'

  def initialize(score)
    @pins = score == STRIKE_MARK ? MAX_PINS : score.to_i
  end
end
