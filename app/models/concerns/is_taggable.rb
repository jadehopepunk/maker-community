module IsTaggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, foreign_key: :taggable_id, dependent: :destroy
    has_many :tags, through: :taggings
  end
end
