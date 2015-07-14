class Game < ActiveRecord::Base
  # TODO has_and_belongs_to_many players
  has_many :players
  has_many :actions, :dependent => :delete_all

  def ready?
    players.size >= 2
  end
end
