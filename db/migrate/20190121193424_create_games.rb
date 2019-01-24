class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :host, index: true, foreign_key: { to_table: :users }
      t.references :guest, index: true, foreign_key: { to_table: :users }
      t.string :puzzle
      t.integer :timer
      t.float :solved
      t.boolean :active
      t.string :title

      t.timestamps
    end
  end
end
