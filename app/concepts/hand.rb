class Hand < Array
  def filter_suit(suit)
    select_from_hand { |card| card.suit == suit }
  end

  def filter_rank(rank)
    select_from_hand { |card| card.rank == rank }
  end

  private

  def select_from_hand(&block)
    cards = select(&block)
    Hand.new(cards)
  end
end
