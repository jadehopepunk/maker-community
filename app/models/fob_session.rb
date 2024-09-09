class FobSession < ApplicationRecord
  belongs_to :fob

  scope :open, -> { where(closed_at: nil) }

  def status
    closed_at ? 'closed' : 'open'
  end
end
