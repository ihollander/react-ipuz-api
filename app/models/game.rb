class Game < ApplicationRecord
  belongs_to :host, class_name: "User", foreign_key: :host_id
  belongs_to :guest, class_name: "User", foreign_key: :guest_id, optional: true
  has_many :messages, dependent: :destroy

  def set_user_active(user, active)
    if self.host == user
      self.host_active = active
      self.save
    elsif self.guest == user
      self.guest_active = active
      self.save
    end
  end

  def actioncable_small_serialize
    ActiveModelSerializers::Adapter::Json.new(
      GameSmallSerializer.new(self)
    ).serializable_hash
  end

end
