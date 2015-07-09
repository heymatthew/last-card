class AddRankAndSuitToCard < ActiveRecord::Migration
  def change
    add_column :cards, :suit, :string
    add_index :cards, :suit
    add_column :cards, :rank, :string
    add_index :cards, :rank
  end
end
