module Events
  class UnpluggedNight < VirtualEvent
    def title
      'Unplugged Night'
    end

    def short_description
      ''
    end

    def event_slug
      'unplugged-night'
    end

    START_DATE = Date.new(2022, 3, 1)

    SESSIONS = {
      2 => {
        start_time: Time.parse('6:30pm UTC'),
        end_time: Time.parse('9:30pm UTC')
      }
    }

    def virtual_sessions_during(date_range)
      result = []

      date_range.map do |date|
        template = SESSIONS[date.wday]
        if template && valid_date?(date)
          result << Events::VirtualEventSession.new(self, date, template[:start_time],
                                                    template[:end_time])
        end
      end

      result
    end

    private

    def valid_date?(date)
      date >= START_DATE && valid_week?(date)
    end

    def valid_week?(date)
      weeks_since_start(date).even?
    end

    def weeks_since_start(date)
      ((date - START_DATE) / 7).to_i
    end
  end
end
