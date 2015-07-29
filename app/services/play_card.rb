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
    top_card = @round.pile.last
    good_rank = @card.rank == top_card.rank
    good_suit = @card.suit == top_card.suit

    # TODO only push errors if invalid card ~~
    @errors.push "cannot play card, expecting suit #{top_card.suit}" unless good_suit
    @errors.push "cannot play card, expecting rank #{top_card.suit}" unless good_rank

    good_rank || good_suit
  end

  def play_card
    @player.play!(@card)
  end
end
