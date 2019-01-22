class Game < ApplicationRecord
  belongs_to :host, class_name: "User", foreign_key: :host_id
  belongs_to :guest, class_name: "User", foreign_key: :guest_id, optional: true
end
