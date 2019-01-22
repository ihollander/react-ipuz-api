class User < ApplicationRecord
  has_many :host_games, class_name: "Game", foreign_key: :host_id
  has_many :guest_games, class_name: "Game", foreign_key: :guest_id

  has_secure_password
  validates :username, uniqueness: { case_sensitive: false }
end
