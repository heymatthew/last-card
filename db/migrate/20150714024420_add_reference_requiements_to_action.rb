class AddReferenceRequiementsToAction < ActiveRecord::Migration
  def change
    change_column_null :actions, :card_id, false
    change_column_null :actions, :player_id, false
    change_column_null :actions, :game_id, false
    change_column_null :actions, :affect, false
  end
end
