class Card
  attr_accessor :rank
  attr_accessor :suit

  RANKS = %w( 2 3 4 5 6 7 8 9 10 jack queen king ace ).freeze
  SUITS = %w( hearts spades diamonds clubs ).freeze

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

  def pickup_count
    return 5 if rank == "5"
    return 2 if rank == "2"
    0
  end

  def pickup?
    pickup_count > 0
  end

  def blocky?
    rank == "7"
  end

  def skippy?
    rank == "10"
  end

  # TODO chosen_suit from that.rank == ace
  def playable_on?(that)
    return true if rank == 'ace'
    return true if that.rank == rank
    return true if that.suit == suit
    false
  end
end
