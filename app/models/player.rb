class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :actions

  validates :user, presence: true
  validates :game, presence: true

  delegate :nickname, to: :user

  def pickups
    actions.pickup
  end

  def plays
    actions.play
  end

  def pickup!(card)
    actions.create!(effect: Action::PICKUP, card: card)
  end

  def play!(card)
    actions.create!(effect: Action::PLAY, card: card)
  end
end
