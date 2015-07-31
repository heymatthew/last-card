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

  # TODO ace has different behaviour
  def assert_legal_move
    top = @round.pile.top
    good_rank = @card.rank == top.rank
    good_suit = @card.suit == top.suit

    return true if good_rank || good_suit

    @errors.push "cannot play card, #{@card.to_s} on #{top.to_s}"
    false
  end

  def play_card
    @player.play!(@card)
  end
end
