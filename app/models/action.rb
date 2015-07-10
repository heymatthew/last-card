class Action < ActiveRecord::Base
  has_one :card
  has_one :player
  belongs_to :game

  PICKUP, PLAY = (0..5).to_a

  validates :card,   presence: true
  validates :player, presence: true
  validates :game,   presence: true

  validates :affect,
    presence: true,
    inclusion: { in: [ PICKUP, PLAY ] }
end
