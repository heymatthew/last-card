class StartGame
  attr_reader :errors

  def initialize(game)
    @game = game
    @errors = []
  end

  def call
    assert_game_ready &&
      remove_pending &&
      shuffle_deck &&
      give_players_cards &&
      play_first_card &&
      save_game

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

  def shuffle_deck
    @deck = Card.deck.shuffle
  end

  def give_players_cards
    # each player picks up 5 cards
    @game.players.each do |player|
      @deck.pop(5).each do |card|
        Action.create!(
          game:   @game,
          player: player,
          card:   card,
          affect: Action::PICKUP,
        )
      end
    end
  end

  def play_first_card
    first_card = @deck.pop
    dealer = @game.players.first

    [ Action::PICKUP, Action::PLAY ].each do |action_affect|
      @game.actions.create!(
        player: dealer,
        card:   first_card,
        affect: action_affect,
      )
    end
  end

  def save_game
    @game.save or
      @errors.push "cannot save game: #{e}"
  end
end
