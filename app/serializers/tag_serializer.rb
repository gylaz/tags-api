class TagSerializer < ActiveModel::Serializer
  attributes :id, :taggable_id, :taggable_type, :labels
end
