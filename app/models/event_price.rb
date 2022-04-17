class EventPrice < ApplicationRecord
  belongs_to :event

  scope :full_first, -> { order(Arel.sql("type = '#{Prices::Full.name}' DESC")) }

  def type_title
    self.class.name.demodulize.humanize.titleize
  end

  def title
    type_title
  end

  def type_css_class
    self.class.name.demodulize.underscore.dasherize
  end

  def full?
    false
  end

  def valid_for?(user)
    error_for(user).blank?
  end

  def error_for(_user)
    nil
  end
end
