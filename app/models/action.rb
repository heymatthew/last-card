class Action < ActiveRecord::Base
  PICKUP = 'pickup'
  PLAY = 'play'

  belongs_to :player

  composed_of :card, class_name: "Card", mapping: [%w(card_rank rank), %w(card_suit suit)]

  scope :pickups,  -> { where(effect: PICKUP) }
  scope :plays,    -> { where(effect: PLAY) }
  scope :in_order, -> { order(:id) }

  validates :player, presence: true
  validates :effect, inclusion: { in: [ PICKUP, PLAY ] }

  validates :card_suit, inclusion: { in: Card::SUITS }
  validates :card_rank, inclusion: { in: Card::RANKS }
end
