class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true
end
