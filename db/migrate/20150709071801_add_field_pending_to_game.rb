class AddFieldPendingToGame < ActiveRecord::Migration
  def change
    add_column :games, :pending, :boolean, :default => true
  end
end
