class Player < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :actions

  # TODO email registration and cookie setting
  validates :nick,
    uniqueness: { message: "already taken, please select another" },
    format: { with: /\A\w+\z/, message: "expecting single word alpha numericy nicks sozlol" }

  def pickups
    actions.pickups
  end

  def plays
    actions.plays
  end

  def pickup(game, card)
    actions.create!(
      affect: Action::PICKUP,
      card: card,
      game: game,
    )
  end

  def play(game, card)
    actions.create!(
      affect: Action::PLAY,
      card: card,
      game: game,
    )
  end
end
