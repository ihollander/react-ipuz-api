class UpdateGamesAgain < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:games, :guest_active, false)
    change_column_default(:games, :host_active, false)
  end
end
