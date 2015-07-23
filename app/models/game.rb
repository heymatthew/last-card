class Game < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_many :actions, :dependent => :destroy

  def ready?
    players.size >= 2
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
