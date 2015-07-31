class Hand < Array
  def filter_suit(suit)
    cards = select { |card| card.suit == suit }
    Hand.new(cards)
  end

  def filter_rank(rank)
    cards = select { |card| card.rank == rank }
    Hand.new(cards)
  end
end
