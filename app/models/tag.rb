class Tag < ActiveRecord::Base
  validates :taggable_id, uniqueness: { scope: :taggable_type }
end
