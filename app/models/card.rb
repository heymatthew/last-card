class Card < ActiveRecord::Base
  has_many :actions, :dependent => :delete_all

  RANKS = %w( 2 3 4 5 6 7 8 9 10 jack queen king ace ).freeze
  SUITS = %w( hearts spades dimonds clubs ).freeze

  validates :rank, inclusion: { in: RANKS }
  validates :suit, inclusion: { in: SUITS }
  validates :suit, uniqueness: {scope: :rank}

  def self.deck
    Card::RANKS.product(Card::SUITS).map do |rank, suit|
      Card.new(rank: rank, suit: suit)
    end
  end
end
