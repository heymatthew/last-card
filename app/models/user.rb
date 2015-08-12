class User < ActiveRecord::Base
  has_many :players, dependent: :destroy
  has_many :games, through: :players

  # TODO email registration and cookie setting
  validates :nickname,
    uniqueness: { message: "already taken, please select another" },
    format: { with: /\A\w+\z/, message: "should be single word alpha numericy nickname~~ sozlol" }
end
