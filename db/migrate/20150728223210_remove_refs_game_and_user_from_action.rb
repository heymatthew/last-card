class RemoveRefsGameAndUserFromAction < ActiveRecord::Migration
  def up
    # Flush data
    execute <<-SQLEND
      DELETE FROM games;
      DELETE FROM actions;
      DELETE FROM players;
    SQLEND

    add_reference :actions, :player, index: true
    remove_column :actions, :game_id
    remove_column :actions, :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
