module VirtualEvents
  class OpenTime < VirtualEvent
    def title
      'Open for Making'
    end

    def short_description
      ''
    end

    def event_slug
      'open-for-making'
    end

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
    }

    def virtual_sessions_during(date_range)
      result = []

      date_range.map do |date|
        template = SESSIONS[date.wday]
        if SESSIONS[date.wday]
          result << VirtualEvents::VirtualEventSession.new(self, date, template[:start_time],
                                                           template[:end_time])
        end
      end

      result
    end
  end
end
