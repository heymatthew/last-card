class Action < ActiveRecord::Base
  PICKUP = 'pickup'
  PLAY = 'play'

  # TODO shuffle?
  # this may make it easier to find the last shuffle

  belongs_to :player

  composed_of :card, class_name: "Card", mapping: [%w(card_rank rank), %w(card_suit suit)]

  scope :pickup,   -> { where(effect: PICKUP) }
  scope :play,     -> { where(effect: PLAY) }
  scope :in_order, -> { order(:id) }

  validates :player, presence: true
  validates :effect, inclusion: { in: [ PICKUP, PLAY ] }

  validates :card_suit, inclusion: { in: Card::SUITS }
  validates :card_rank, inclusion: { in: Card::RANKS }
end
