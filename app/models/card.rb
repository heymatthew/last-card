class Card < ActiveRecord::Base
  has_many :actions, :dependent => :delete_all

  RANKS = %w( 2 3 4 5 6 7 8 9 10 jack queen king ace ).freeze
  SUITS = %w( hearts spades dimonds clubs ).freeze

  validates :rank, inclusion:  { in: RANKS }
  validates :suit, inclusion:  { in: SUITS }
  validates :suit, uniqueness: { scope: :rank }

  def self.deck
    self.all
  end

  def to_s
    "#{rank.capitalize} of #{suit.capitalize}"
  end
end
