class Event < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: true
  has_many :sessions, class_name: 'EventSession', dependent: :destroy
  has_many :prices, class_name: 'EventPrice', dependent: :destroy
  belongs_to :image, optional: true, dependent: :destroy

  scope :duty_managed, -> { where(duty_managed: true) }
  scope :special_event, -> { where(duty_managed: false) }
end
