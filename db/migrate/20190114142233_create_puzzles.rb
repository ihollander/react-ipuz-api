class CreatePuzzles < ActiveRecord::Migration[5.2]
  def change
    create_table :puzzles do |t|
      t.string :title
      t.string :ipuz
      t.string :cells
      t.integer :timer
      t.references :user

      t.timestamps
    end
  end
end
