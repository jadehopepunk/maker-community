class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, polymorphic: true
end
