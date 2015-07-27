class DropInvalidActions < ActiveRecord::Migration
  def up
    #Action.where(card:nil).each(&:destroy)
    #Action.where(game:nil).each(&:destroy)
    #Action.where(player:nil).each(&:destroy)

    execute <<-ENDSQL
      DELETE FROM actions
      WHERE card_id IS NULL
         OR game_id IS NULL
         OR player_id IS NULL
    ENDSQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
