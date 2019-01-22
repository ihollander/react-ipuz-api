class GameSmallSerializer < ActiveModel::Serializer
  attributes :id, :title, :solved, :timer, :host_active, :guest_active, :updated_at

  has_one :host, key: :host_id
  has_one :guest, key: :guest_id
end
