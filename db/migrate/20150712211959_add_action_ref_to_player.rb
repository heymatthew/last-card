class AddActionRefToPlayer < ActiveRecord::Migration
  def change
    add_reference :players, :action, index: true, foreign_key: true
  end
end
