module Events
  class OpenTimeEvent < WeekdayRecurringEvent
    SESSIONS = {
      1 => {
        start_time: Time.zone.parse('6:30pm'),
        end_time: Time.zone.parse('9:30pm')
      },
      4 => {
        start_time: Time.zone.parse('6:30pm'),
        end_time: Time.zone.parse('9:30pm')
      },
      6 => {
        start_time: Time.zone.parse('10:00am'),
        end_time: Time.zone.parse('4:00pm')
      }
    }.freeze

    private

    def template_for_date(date)
      SESSIONS[date.wday]
    end
  end
end
