module Events
  class WeekdayRecurringEvent < ::Event
    def build_sessions_for_date_range(date_range)
      result = []

      date_range.map do |date|
        template = template_for_date(date)
        next unless template

        start_at = combine_date_and_time(date, template[:start_time])
        end_at = combine_date_and_time(date, template[:end_time])

        next if sessions.where(start_at:).exists?

        result << sessions.build(start_at:, end_at:)
      end

      result
    end

    private

    def combine_date_and_time(date, time)
      Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
    end
  end
end
