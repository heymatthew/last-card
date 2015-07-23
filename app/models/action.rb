class Action < ActiveRecord::Base
  belongs_to :card
  belongs_to :player
  belongs_to :game

  PICKUP = 0
  PLAY = 1

  validates :card,   presence: true
  validates :player, presence: true
  validates :game,   presence: true

  validates :affect,
    presence: true,
    inclusion: { in: [ PICKUP, PLAY ] }

  scope :pickup, -> { where(affect: PICKUP) }
  scope :play,   -> { where(affect: PLAY) }
end
