class Player < ActiveRecord::Base
  # TODO has_and_belongs_to_many games
  belongs_to :game
  has_many :actions
end
