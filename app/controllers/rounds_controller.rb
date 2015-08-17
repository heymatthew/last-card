class RoundsController < ApplicationController
  before_filter :setup_game
  before_filter :setup_round

  def index
    render(json: round_hash)
  end

  private

  def round_hash
    {
      hands: @round.hands,
      pile: @round.pile,
      deck: @round.deck,
    }
  end
end
