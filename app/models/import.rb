class Import < ApplicationRecord
  def self.record
    Import.first || Import.create!
  end
end
