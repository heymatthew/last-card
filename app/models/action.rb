class Action < ActiveRecord::Base
  belongs_to :card
  belongs_to :player
  belongs_to :game

  # store as strings plz
  PICKUP = 0
  PLAY = 1

  # FIXME Either have one action per turn with multiple cards played
  # OR merge card into this class

  validates :card,   presence: true
  validates :player, presence: true
  validates :game,   presence: true

  validates :affect,
    presence: true,
    inclusion: { in: [ PICKUP, PLAY ] }

  scope :pickup, -> { where(affect: PICKUP) }
  scope :play,   -> { where(affect: PLAY) }
end
