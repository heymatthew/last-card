class PickupCard
  attr_reader :errors

  def initialize(player, round)
    @player = player
    @round  = round
    @errors = []
  end

  def call
    @round.game.with_lock do
      assert_cards_available && pickup_card
    end

    @errors.none?
  end

  private

  def assert_cards_available
    return true if @round.deck.any?
    @errors.push "no cards in deck"
    false
  end

  def pickup_card
    card = @round.deck.pickup
    @player.pickup!(card)
  end
end
