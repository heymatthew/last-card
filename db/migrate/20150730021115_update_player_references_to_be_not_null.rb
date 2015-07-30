class UpdatePlayerReferencesToBeNotNull < ActiveRecord::Migration
  def change
    change_column_null :players, :user_id, false
    change_column_null :players, :game_id, false
  end
end
