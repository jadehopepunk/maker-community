module Events
  class UnpluggedNightEvent < WeekdayRecurringEvent
    SESSIONS = {
      2 => {
        start_time: Time.zone.parse('6:30pm'),
        end_time: Time.zone.parse('9:30pm')
      }
    }.freeze

    START_DATE = Date.new(2022, 3, 1)
    END_DATE = Date.new(2022, 4, 30)

    private

    def template_for_date(date)
      SESSIONS[date.wday] if valid_date?(date)
    end

    def valid_date?(date)
      date >= START_DATE && date <= END_DATE && valid_week?(date)
    end

    def valid_week?(date)
      weeks_since_start(date).even?
    end

    def weeks_since_start(date)
      ((date - START_DATE) / 7).to_i
    end
  end
end
