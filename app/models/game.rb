class Game < ActiveRecord::Base
  # TODO has_and_belongs_to_many players
  has_many :players
  has_many :actions
  # TODO test all refs before committing
  # TODO commit ref web together

  def ready?
    players.size >= 2
  end
end
