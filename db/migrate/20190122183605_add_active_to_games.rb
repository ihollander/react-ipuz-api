class AddActiveToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :host_active, :boolean
    add_column :games, :guest_active, :boolean
  end
end
