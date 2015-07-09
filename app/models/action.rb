class Action < ActiveRecord::Base
  has_one :card
  has_one :player
  belongs_to :game

  validates :card, presence: true
  validates :player, presence: true
  validates :game, presence: true
end
