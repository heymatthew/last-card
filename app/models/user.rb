class User < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :games, through: :players
  validates :email, uniqueness: { message: "already taken, please select another" }
end
