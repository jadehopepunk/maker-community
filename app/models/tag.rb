class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings, source: :taggable
end
