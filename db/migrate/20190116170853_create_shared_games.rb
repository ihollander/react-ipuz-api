class CreateSharedGames < ActiveRecord::Migration[5.2]
  def change
    create_table :shared_games do |t|
      t.references :puzzle

      t.timestamps
    end
  end
end
