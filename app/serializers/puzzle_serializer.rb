class PuzzleSerializer < ActiveModel::Serializer
  attributes :id, :ipuz, :title, :cells, :timer
end
