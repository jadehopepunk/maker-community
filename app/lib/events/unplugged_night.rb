module Events
  class UnpluggedNight
    def title
      'Unplugged Night'
    end

    def short_description
      ''
    end

    SESSIONS = {
      2 => {
        start_time: Time.parse('6:30pm UTC'),
        end_time: Time.parse('9:30pm UTC')
      }
    }

    def sessions_during(date_range)
      result = []

      date_range.map do |date|
        template = SESSIONS[date.wday]
        if SESSIONS[date.wday]
          result << Events::VirtualEventSession.new(self, date, template[:start_time],
                                                    template[:end_time])
        end
      end

      result
    end
  end
end
