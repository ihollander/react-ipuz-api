class DropPuzzlesAndSharedGames < ActiveRecord::Migration[5.2]
  def change
    drop_table :puzzles
    drop_table :shared_games
  end
end
