class Area < ApplicationRecord
  belongs_to :image

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name slug]
  end
end
