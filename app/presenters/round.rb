class Round < Struct.new(:game)
  def hands
    @hands ||= calculate_hands
  end

  def pile
    @pile ||= calculate_shuffled_pile
  end

  def deck
    @deck ||= calculate_deck
  end

  private

  # FIXME 52 pickups is fine for the first shuffle
  # But subsequent pickups will trigger from running through the deck height
  # which will not be 52 the second time
  # If the deck is size 20 after the first shuffle
  # the second shuffle will be at 72 pickups!
  def calculate_shuffled_pile
    shuffle_count = game.pickups.count / Deck::PLATONIC.size

    if shuffle_count.zero?
      # If we've not shuffled, just show all cards played
      pile_cards = game.plays.in_order.map(&:card)
    else
      # Find the card that triggered the shuffle
      @shuffle_trigger = game.pickups.in_order[ Deck::PLATONIC.size * shuffle_count - 1 ]

      # Pile will be previous pile's top card + played cards since then
      pile_cards = previous_top_card.concat played_since_shuffle
    end

    Pile.new(pile_cards)
  end

  def previous_top_card
    [ plays_before_shuffle.last ]
  end

  def plays_before_shuffle
     game.plays.in_order.where("actions.id < ?", @shuffle_trigger.id).map(&:card)
  end

  def played_since_shuffle
    game.plays.in_order.where("actions.id > ?", @shuffle_trigger.id).map(&:card)
  end

  def cards_in_play
    pile + hands.values.flatten
  end

  def calculate_deck
    deck_cards = Deck::PLATONIC - cards_in_play
    Deck.new(deck_cards)
  end

  def calculate_hands
    game.players.each.with_object({}) do |player, hands|
      pickups = player.pickups.map(&:card)
      plays = player.plays.map(&:card)
      hands[player.email] = Hand.new(pickups - plays)
    end
  end

  def empty_pile
    Pile.new
  end
end
