class AddPlayerRefToActions < ActiveRecord::Migration
  def change
    add_reference :actions, :player, index: true, foreign_key: true
  end
end
