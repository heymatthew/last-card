class StartGame
  attr_reader :errors

  def initialize(game)
    @game = game
    @errors = []
  end

  def call
    assert_game_ready &&
      remove_pending &&
      give_players_cards

    @errors.none?
  end

  private

  def assert_game_ready
    @game.ready?.tap do |ready|
      @errors.push "game not ready to start" if !ready
    end
  end

  def remove_pending
    @game.pending.tap do |pending|
      if pending
        @game.pending = false
      else
        @errors.push "game already started"
      end
    end
  end

  def give_players_cards
    # FIXME card should come from deck
    @game.players.each do |player|
      5.times do
        Action.create(
          game:   @game,
          player: player,
          card:   Card.first,
          affect: Action::PICKUP,
        )
      end
    end
  end
end
