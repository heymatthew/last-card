class Game < ActiveRecord::Base
  has_many :players, :dependent => :destroy
  has_many :users, through: :players
  has_many :actions, through: :players

  has_one :nickname, through: :user

  def ready?
    users.size >= 2
  end

  def started?
    !pending
  end

  def plays
    actions.play
  end

  def pickups
    actions.pickup
  end
end
