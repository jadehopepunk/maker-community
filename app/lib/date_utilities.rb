class DateUtilities
  class << self
    def to_datetime_range(date_range)
      return date_range if date_range.first.is_a?(DateTime)

      (date_range.first.to_datetime)..((date_range.last + 1).to_datetime)
    end
  end
end
