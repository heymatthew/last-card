class AddAffectToAction < ActiveRecord::Migration
  def change
    add_column :actions, :affect, :integer
    add_index :actions, :affect
  end
end
