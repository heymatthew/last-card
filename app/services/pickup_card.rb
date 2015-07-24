class PickupCard
  attr_reader :errors

  def initialize(player, round)
    @player = player
    @round  = round
    @errors = []
  end

  def call
    assert_game_in_play &&
      assert_cards_available &&
      pickup_card

    @errors.none?
  end

  private

  # TODO remove tap
  def assert_game_in_play
    @round.game.started?.tap do |started|
      @errors.push "game not started" unless started
    end
  end

  def assert_cards_available
    @round.deck.any?.tap do |deck_has_cards|
      @errors.push "no cards in deck" unless deck_has_cards
    end
  end

  def pickup_card
    card = @round.deck.sample
    game = @round.game
    @player.pickup!(game, card)
  end
end
