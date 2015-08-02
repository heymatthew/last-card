class Card
  attr_accessor :rank
  attr_accessor :suit

  RANKS = %w( 2 3 4 5 6 7 8 9 10 jack queen king ace ).freeze
  SUITS = %w( hearts spades dimonds clubs ).freeze

  def initialize(rank, suit)
    @suit, @rank = suit, rank
  end

  # Note, this goes below the initialize method
  # If not, ruby wont define new() correctly
  DECK = RANKS.product(SUITS).map { |rank, suit| Card.new(rank, suit) }.freeze

  def ==(that)
    @suit == that.suit && @rank == that.rank
  end

  def eql?(that)
    self == that
  end

  def eq?(that)
    self == that
  end

  def hash
    [@rank, @suit].hash
  end

  def to_s
    "#{rank.capitalize} of #{suit.capitalize}"
  end

  def pickup
    return 5 if rank == "5"
    return 2 if rank == "2"
  end

  def blocky?
    rank == "7"
  end

  def skippy?
    rank == "10"
  end
end
