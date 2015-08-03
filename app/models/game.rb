class Game < ActiveRecord::Base
  MINIMUM_PLAYERS = 2

  has_many :players, :dependent => :destroy

  has_many :users, through: :players
  has_many :actions, through: :players
  has_one :nickname, through: :user

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

  validate :round_counter_is_positive

  private

  def round_counter_is_positive
    if round_counter.class != Fixnum || round_counter < 0
      errors.add(:round_counter, "positive integers only")
      return false
    end
  end
end
