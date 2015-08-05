class UpdateFixSpellingDiamondsOnAction < ActiveRecord::Migration
  def up
    execute <<-SQLEND
      UPDATE actions
      SET card_suit = 'diamonds'
      WHERE card_suit = 'dimonds'
    SQLEND
  end

  def down
    execute <<-SQLEND
      UPDATE actions
      SET card_suit = 'dimonds'
      WHERE card_suit = 'diamonds'
    SQLEND
  end
end
