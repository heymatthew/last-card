class AddOauth2FieldsToUser < ActiveRecord::Migration
  def up
    execute <<-SQLEND
      DELETE FROM actions;
      DELETE FROM players;
      DELETE FROM users;
      DELETE FROM games;
    SQLEND

    rename_column :users, :nickname, :email
    rename_index :users, :index_users_on_nickname, :index_users_on_email

    add_column :users, :firstname, :string
    add_column :users, :name, :string
    add_column :users, :image, :string
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
