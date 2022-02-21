class Event < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :event_sessions, dependent: :destroy
  belongs_to :image, optional: true, dependent: :destroy
end
