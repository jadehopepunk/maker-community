module IsTaggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, foreign_key: :taggable, inverse_of: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
    before_validation :bind_taggings
  end

  # def tag_list=(tag_slugs)
  #   tag_slugs.each do |tag_slug|
  #     tag = Tag.find_or_create_by(slug: tag_slug)
  #     taggings.find_or_create_by(tag:)
  #   end
  # end

  def bind_taggings
    raise "fisH! #{self}"
  end
end
