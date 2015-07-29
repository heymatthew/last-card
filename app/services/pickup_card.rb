class PickupCard
  attr_reader :errors

  def initialize(player, round)
    @player = player
    @round  = round
    @errors = []
  end

  def call
    assert_cards_available && pickup_card

    @errors.none?
  end

  private

  # TODO Remove tap
  def assert_cards_available
    return true if @round.deck.any?
    @errors.push "no cards in deck"
    false
  end

  def pickup_card
    card = @round.deck.sample
    @player.pickup!(card)
  end
end
