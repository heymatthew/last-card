class Game < ActiveRecord::Base
  # TODO has_and_belongs_to_many players
  has_many :players
end
