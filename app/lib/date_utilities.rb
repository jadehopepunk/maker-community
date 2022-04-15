class DateUtilities
  class << self
    def date_range_to_datetime_range(date_range)
      return date_range if date_range.first.is_a?(DateTime)

      (date_range.first.to_time)..((date_range.last + 1).to_time)
    end

    def date_to_datetime_range(date)
      date.to_time..(date.to_time + 1.day)
    end
  end
end
