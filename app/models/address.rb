class Address < ApplicationRecord
  validates :address_1, :city, :state, :postcode, :country_code, presence: true
end
