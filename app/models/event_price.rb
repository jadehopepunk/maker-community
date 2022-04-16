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
end
