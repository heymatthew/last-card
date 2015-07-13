class UpdateCardForceRankAndSuit < ActiveRecord::Migration
  def change
    change_column_null :cards, :suit, false
    change_column_null :cards, :rank, false
  end
end
