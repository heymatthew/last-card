class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :actions, dependent: :destroy

  validates :user, presence: true
  validates :game, presence: true

  delegate :email, to: :user
  delegate :plays, :pickups, :shuffles, to: :actions

  def pickup!(card)
    actions.pickups.create!(card: card)
  end

  def play!(card)
    actions.plays.create!(card: card)
  end

  def shuffle!
    actions.shuffle.create!
  end
end
