module CardDeck
  RANKS = %w( 2 3 4 5 6 7 8 9 10 jack queen king ace ).freeze
  SUITS = %w( hearts spades dimonds clubs ).freeze

  CARDS = RANKS.product(SUITS).map do |rank, suit|
    Card.new(rank, suit)
  end.freeze
end
