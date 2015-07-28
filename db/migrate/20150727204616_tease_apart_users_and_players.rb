class TeaseApartUsersAndPlayers < ActiveRecord::Migration
  def change
    # Rename players to users
    rename_table :players, :users
    rename_column :actions, :player_id, :user_id
    rename_column :games_players, :player_id, :user_id
    rename_index :players, :index_actions_on_player_id, :index_actions_on_user_id

    # Rename join table to players, and reference users
    rename_table :games_players, :players
    rename_index :players, :index_games_players_on_game_id, :index_games_users_on_game_id
    rename_index :players, :index_games_players_on_player_id, :index_games_users_on_player_id
  end
end
