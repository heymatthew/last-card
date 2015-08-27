# TODO move this to services
Round = Struct.new(:game) do
  def hands
    @hands ||= calculate_hands
  end

  def pile
    @pile ||= Pile.new(prepare_pile)
  end

  def deck
    @deck ||= Deck.new(prepare_deck)
  end

  private

  def prepare_pile
    if shuffle_count.zero?
      # If we've not shuffled, just show all cards played
      game.plays.in_order.map(&:card)
    else
      # Otherwise, we need previous pile's top card + played cards since then
      previous_top_card.concat played_since_shuffle
    end
  end

  def shuffle_count
    game.shuffles.size
  end

  def shuffle_trigger
    game.shuffles.last
  end

  def previous_top_card
    [ plays_before_shuffle.last ]
  end

  def plays_before_shuffle
     game.plays.in_order.where("actions.id < ?", shuffle_trigger.id).map(&:card)
  end

  def played_since_shuffle
    game.plays.in_order.where("actions.id > ?", shuffle_trigger.id).map(&:card)
  end

  def cards_in_play
    pile + hands.values.flatten
  end

  # Change to be cheeper
  # 1. Find deck size from suffle trigger
  # 2. Remove pickups
  #   ...try make this work with scopes
  #   ...do add indexes to make this fast
  def prepare_deck
    Deck::PLATONIC - cards_in_play
  end

  def calculate_hands
    game.players.each.with_object({}) do |player, hands|
      pickups = player.pickups.map(&:card)
      plays = player.plays.map(&:card)
      hands[player.id] = Hand.new(pickups - plays)
    end
  end

  def empty_pile
    Pile.new
  end
end