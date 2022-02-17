class Image < ApplicationRecord
  has_one_attached :file do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
end
