class EventPrice < ApplicationRecord
  belongs_to :event

  def type_title
    self.class.name.demodulize.humanize.titleize
  end
end
