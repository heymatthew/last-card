class AddGameRefToPlayers < ActiveRecord::Migration
  def change
    add_reference :players, :game, index: true, foreign_key: true
  end
end
