class Area < ApplicationRecord
  belongs_to :image

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
