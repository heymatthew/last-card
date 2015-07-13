class Action < ActiveRecord::Base
  belongs_to :card
  belongs_to :player
  belongs_to :game

  PICKUP, PLAY = (0..5).to_a

  validates :card,   presence: true
  validates :player, presence: true
  validates :game,   presence: true

  validates :affect,
    presence: true,
    inclusion: { in: [ PICKUP, PLAY ] }
end
