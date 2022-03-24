class Event < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true
  has_many :sessions, class_name: 'EventSession', dependent: :destroy
  belongs_to :image, optional: true, dependent: :destroy
end
