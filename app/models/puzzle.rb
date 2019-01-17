class Puzzle < ApplicationRecord
  belongs_to :user
  has_many :shared_games
end
