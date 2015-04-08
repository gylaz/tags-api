class EntitySerializer < ActiveModel::Serializer
  root false
  attributes :id, :type, :labels

  delegate :labels, to: :object

  def id
    object.taggable_id
  end

  def type
    object.taggable_type
  end
end
