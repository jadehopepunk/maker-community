class DateUtilities
  class << self
    def date_range_to_datetime_range(date_range)
      return date_range if date_range.first.is_a?(DateTime)

      (date_to_time_in_zone(date_range.first).beginning_of_day)..(date_to_time_in_zone(date_range.last).end_of_day)
    end

    def date_to_datetime_range(date)
      date_in_zone = date.to_time.in_time_zone(Time.zone)
      date_in_zone.beginning_of_day..date_in_zone.end_of_day
    end

    def date_to_time_in_zone(date)
      date.to_time.in_time_zone(Time.zone)
    end

    def next_n_hours(number)
      start = Time.current
      start..(start + number.hours)
    end
  end
end
