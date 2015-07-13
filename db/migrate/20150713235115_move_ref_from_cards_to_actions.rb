class MoveRefFromCardsToActions < ActiveRecord::Migration
  def change
    remove_reference :cards, :action
    add_reference :actions, :card, index: true
  end
end
