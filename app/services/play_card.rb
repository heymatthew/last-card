require 'rails_helper'

class PlayCard
  attr_reader :errors

  def initialize(player, round, card)
    @player = player
    @round  = round
    @card   = card
    @errors = []
  end

  def call
    @errors.push "implement me fool!"
    @errors.none?
  end
end
