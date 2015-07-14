class AddColumnNickToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :nick, :string
    add_index :players, :nick, :unique => true
  end
end
