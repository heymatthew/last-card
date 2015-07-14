class DropInvalidActions < ActiveRecord::Migration
  def up
    Action.where(card:nil).each(&:destroy)
    Action.where(game:nil).each(&:destroy)
    Action.where(player:nil).each(&:destroy)
  end
end
