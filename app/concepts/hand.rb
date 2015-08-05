class Hand < Array
  def filter_suit(suit)
    select_from_hand { |card| card.suit == suit }
  end

  def filter_rank(rank)
    select_from_hand { |card| card.rank == rank }
  end

  def select_playable(top_card)
    select_from_hand { |card| card.playable_on?(top_card) }
  end

  def pickup_defence(top_card)
    select_playable(top_card)
      .select_from_hand { |card| card.pickup? || card.block? }
  end

  protected

  def select_from_hand(&block)
    cards = select(&block)
    Hand.new(cards)
  end
end
