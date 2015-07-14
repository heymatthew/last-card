class CreateTableGamePlayers < ActiveRecord::Migration
  def change
    create_table :games_players do |t|
      t.timestamps null: false
      t.references :player, index: true
      t.references :game, index: true
    end

    remove_reference :players, :action
    remove_reference :games, :action
  end
end
