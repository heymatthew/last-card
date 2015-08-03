class AddRoundCounterToGame < ActiveRecord::Migration
  def change
    add_column :games, :round_counter, :integer, default: 0
  end
end
