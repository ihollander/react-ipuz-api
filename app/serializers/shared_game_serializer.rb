class SharedGameSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :puzzle
  
end
