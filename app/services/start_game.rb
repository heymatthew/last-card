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
    @game.players.each do |player|
      @deck.pop(5).each do |card|
        player.pickup!(@game, card)
      end
    end
  end

  def play_first_card
    first_card = @deck.pop
    dealer = @game.players.first

    dealer.pickup!(@game, first_card)
    dealer.play!(@game, first_card)
  end

  def save_game
    @game.save!
  end
end
