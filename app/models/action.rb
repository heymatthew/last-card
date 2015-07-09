class Action < ActiveRecord::Base
  has_one :card
  has_one :player
  belongs_to :game
end
