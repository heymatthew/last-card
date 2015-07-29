class Round
  def initialize(game)
    @game = game
  end

  def hands
    return @hands if @hands.present?

    @hands = {}
    if @game.started?
      @game.players.each do |player|
        pickups = player.pickups.map(&:card)
        plays = player.plays.map(&:card)
        @hands[player.nickname] = pickups - plays
      end
    end

    @hands
  end

  def deck
    return @deck if @deck.present?
    @deck = Card.deck - cards_in_play
  end

  def pile
    return @pile if @pile.present?

    if @game.started?
      @pile = calculate_shuffled_pile
    else
      @pile = []
    end
  end

  private

  def calculate_shuffled_pile
    shuffle_count = @game.pickups.count / Card.deck.size

    # Just return played cards if we've not shuffled yet
    return @game.plays.map(&:card) if shuffle_count.zero?

    # Find the card that triggered the shuffle
    shuffle_trigger = @game.pickups[ Card.deck.size * shuffle_count - 1 ]
    shuffle_time = shuffle_trigger.created_at

    # Pile will be previous pile's top card + played cards since then
    previous_top_card(shuffle_time).concat played_since_shuffle(shuffle_time)
  end

  def previous_top_card(shuffle_time)
    # TODO use ids instead of times
    [ @game.plays.where("actions.created_at < ?", shuffle_time).last.card ]
  end

  def played_since_shuffle(shuffle_time)
    @game.plays.where("actions.created_at > ?", shuffle_time).map(&:card)
  end


  def cards_in_play
    pile + hands.values.flatten
  end
end
