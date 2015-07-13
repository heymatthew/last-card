class AddUniqueConstraintsToCard < ActiveRecord::Migration
  def change
    add_index :cards, [:rank, :suit], unique: true
  end
end
