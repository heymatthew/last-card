class CreateCardDeck < ActiveRecord::Migration
  def up
    Card.destroy_all
    Card::RANKS.product(Card::SUITS).map do |rank, suit|
      Card.create!(rank: rank, suit: suit)
    end
  end

  def down
    Card.destroy_all
  end
end
