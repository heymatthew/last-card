class AddActionRefToCards < ActiveRecord::Migration
  def change
    add_reference :cards, :action, index: true, foreign_key: true
  end
end
