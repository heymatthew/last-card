class StartGame
  attr_reader :errors

  def initialize(game)
    @game = game
    @errors = []
  end

  def call
    @game.with_lock do
      assert_game_ready &&
        remove_pending &&
        shuffle_deck &&
        give_players_cards &&
        play_first_card &&
        save_game!
    end

    @errors.none?
  end

  private

  def assert_game_ready
    return true if @game.ready?
    @errors.push "game not ready to start"
    false
  end

  def remove_pending
    if @game.pending
      @game.pending = false
      return true
    end

    @errors.push "game already started"
    false
  end

  def shuffle_deck
    @deck = Deck::PLATONIC.shuffle
  end

  def give_players_cards
    @game.players.each do |player|
      @deck.pop(5).each do |card|
        player.pickup!(card)
      end
    end
  end

  def play_first_card
    first_card = @deck.pop
    dealer = @game.players.first

    dealer.pickup!(first_card)
    dealer.play!(first_card)
  end

  def save_game!
    @game.save!
  end
end
