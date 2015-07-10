class Card < ActiveRecord::Base
  belongs_to :action

  # TODO notes, Ruby makes these available as constants!
  RANKS = %w( 2 3 4 5 6 7 8 9 10 jack queen king ace ).freeze
  SUITS = %w( hearts spades dimons clubs ).freeze

  validates :rank,
    presence: true,
    inclusion: { in: RANKS }

  validates :suit,
    presence: true,
    inclusion: { in: SUITS }
end
