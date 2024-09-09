class Fob < ApplicationRecord
  belongs_to :user, optional: true
  has_many :sessions, class_name: 'FobSession'
end
