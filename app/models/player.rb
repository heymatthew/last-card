class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :actions, dependent: :destroy

  validates :user, presence: true
  validates :game, presence: true

  delegate :email, to: :user

  def pickups
    actions.pickup
  end

  def plays
    actions.play
  end

  def pickup!(card)
    actions.pickup.create!(card: card)
  end

  def play!(card)
    actions.play.create!(card: card)
  end
end
