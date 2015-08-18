class RoundsController < ApplicationController
  before_filter :setup_game
  before_filter :setup_round

  def index
    render(json: round_cards)
  end

  private

  def round_cards
    flattened_deck
      .concat(flattened_hands)
      .concat(flattened_pile)
  end

  def flattened_hands
    @round.hands.map do |nickname, hand|
      hand.map { |card| format_card(card, nickname) }
    end
  end

  def flattened_deck
    @round.deck.map { |card| format_card(card, 'deck') }
  end

  def flattened_pile
    @round.pile.map { |card| format_card(card, 'pile') }
  end

  def format_card(card, position)
    {
      suit:     card.suit,
      rank:     card.rank,
      position: position,
    }
  end
end
