class CreateCardDeck < ActiveRecord::Migration
  def up
    Card.destroy_all
    Card.deck.each { |card| card.save! }
  end

  def down
    Card.destroy_all
  end
end
