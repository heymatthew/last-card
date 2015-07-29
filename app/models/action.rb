class Action < ActiveRecord::Base
  PICKUP, PLAY = %w(pickup play)

  belongs_to :card
  belongs_to :player

  scope :pickup, -> { where(effect: PICKUP) }
  scope :play,   -> { where(effect: PLAY) }

  # FIXME Either have one action per turn with multiple cards played
  # OR merge card into this class

  validates :card, presence: true
  validates :player, presence: true
  validates :effect,
    presence: true,
    inclusion: { in: [ PICKUP, PLAY ] }
end
