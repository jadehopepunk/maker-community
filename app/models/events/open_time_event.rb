module Events
  class OpenTimeEvent < WeekdayRecurringEvent
    SESSIONS = {
      1 => {
        start_time: Time.parse('6:30pm UTC'),
        end_time: Time.parse('9:30pm UTC')
      },
      4 => {
        start_time: Time.parse('6:30pm UTC'),
        end_time: Time.parse('9:30pm UTC')
      },
      6 => {
        start_time: Time.parse('10:00am UTC'),
        end_time: Time.parse('4:00pm UTC')
      }
    }.freeze

    private

    def template_for_date(date)
      SESSIONS[date.wday]
    end
  end
end
