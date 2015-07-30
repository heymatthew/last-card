class CreateCardDeck < ActiveRecord::Migration
  include ActiveRecord::Sanitization::ClassMethods

  RANKS = %w( 2 3 4 5 6 7 8 9 10 jack queen king ace ).freeze
  SUITS = %w( hearts spades dimonds clubs ).freeze
  INSERT_CARD = <<-ENDSQL
    INSERT INTO cards(rank, suit, created_at, updated_at)
    VALUES(?, ?, ?, ?)
  ENDSQL

  def up
    execute "DELETE FROM cards"

    now = Time.now
    RANKS.product(SUITS).map do |rank, suit|
      execute sanitize_sql_array([
        INSERT_CARD, rank, suit, now, now
      ])
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
