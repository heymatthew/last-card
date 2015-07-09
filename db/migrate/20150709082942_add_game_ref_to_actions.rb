class AddGameRefToActions < ActiveRecord::Migration
  def change
    add_reference :actions, :game, index: true, foreign_key: true
  end
end
