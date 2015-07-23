class RenameColumnNickToNickname < ActiveRecord::Migration
  def change
    change_table :players do |t|
      t.rename :nick, :nickname
    end
  end
end
