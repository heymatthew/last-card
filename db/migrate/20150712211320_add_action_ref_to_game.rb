class AddActionRefToGame < ActiveRecord::Migration
  def change
    add_reference :games, :action, index: true, foreign_key: true
  end
end
