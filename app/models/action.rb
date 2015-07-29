class Action < ActiveRecord::Base
  belongs_to :card
  belongs_to :player

  PICKUP, PLAY = %w(pickup play)

  # FIXME Either have one action per turn with multiple cards played
  # OR merge card into this class

  validates :card, presence: true
  validates :player, presence: true
  validates :effect,
    presence: true,
    inclusion: { in: [ PICKUP, PLAY ] }

  scope :pickup, -> { where(effect: PICKUP) }
  scope :play,   -> { where(effect: PLAY) }
end
