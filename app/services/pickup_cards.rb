class PickupCards < Struct.new(:player, :round, :pickups)
  def call
    round.game.with_lock do
      validate_cards_available
      pickup_card if errors.none?
    end

    errors.none?
  end

  def errors
    @errors ||= []
  end

  private

  def validate_cards_available
    errors << "no cards in deck" if round.deck.none?
  end

  def pickup_card
    card = round.deck.pickup
    player.pickup!(card)
  end

  # TODO increment round fool!
end
