class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :user, :created_at
end
