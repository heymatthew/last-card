class DropCardModel < ActiveRecord::Migration
  def change
    execute "DELETE FROM ACTIONS"

    add_column :actions, :card_suit, :string
    add_column :actions, :card_rank, :string

    remove_column :actions, :card_id
    drop_table :cards
  end
end
