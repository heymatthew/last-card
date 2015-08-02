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
    @round.game.with_lock do
      assert_legal_move && play_card
    end

    @errors.none?
  end

  private

  def assert_legal_move
    top_card = @round.pile.top
    return true if @card.playable_on?(top_card)

    @errors.push "cannot play card, #{@card.to_s} on #{top_card}"
    false
  end

  def play_card
    @player.play!(@card)
  end
end
