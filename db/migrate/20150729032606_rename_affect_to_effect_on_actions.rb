class RenameAffectToEffectOnActions < ActiveRecord::Migration
  PICKUP = 0
  PLAY = 1

  def change
    add_column :actions, :effect, :string
    add_index :actions, :effect

    execute "UPDATE actions SET effect = 'pickup' WHERE affect = #{PICKUP}"
    execute "UPDATE actions SET effect = 'play' WHERE affect = #{PLAY}"

    remove_column :actions, :affect
  end
end
