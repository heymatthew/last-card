class Player < ActiveRecord::Base
  # FIXME Don't use this
  # belongs to game
  # belongs to user
  has_and_belongs_to_many :games
  has_many :actions

  # TODO email registration and cookie setting
  validates :nickname,
    uniqueness: { message: "already taken, please select another" },
    format: { with: /\A\w+\z/, message: "expecting single word alpha numericy nickname~~ sozlol" }

  # TODO this should all be in player
  def pickups
    actions.pickup
  end

  def plays
    actions.play
  end

  def pickup!(game, card)
    actions.create!(
      affect: Action::PICKUP,
      card: card,
      game: game,
    )
  end

  def play!(game, card)
    actions.create!(
      affect: Action::PLAY,
      card: card,
      game: game,
    )
  end
end
