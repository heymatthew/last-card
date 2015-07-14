class Game < ActiveRecord::Base
  has_and_belongs_to_many :players
  has_many :actions, :dependent => :delete_all

  def ready?
    players.size >= 2
  end
end
