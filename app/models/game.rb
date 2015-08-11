class Game < ActiveRecord::Base
  MINIMUM_PLAYERS = 2

  has_many :players, dependent: :destroy

  has_many :users, through: :players
  has_many :actions, through: :players

  validates :round_counter, numericality: { only_integer: true }

  # TODO should a user kill themselves
  # we should end the game

  def ready?
    users.size >= MINIMUM_PLAYERS
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

  def current_turn
    turn = round_counter % players.count
    players[turn]
  end
end
