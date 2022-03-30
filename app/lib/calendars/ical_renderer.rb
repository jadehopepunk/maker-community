require 'icalendar'
require 'icalendar/tzinfo'

module Calendars
  class IcalRenderer
    attr_reader :cal

    def initialize(cal)
      @cal = cal
    end

    def to_s
      build_ical.to_ical
    end

    def build_ical
      ical = Icalendar::Calendar.new

      ical.add_timezone build_timezone
      ical.append_custom_property 'X-WR-CALNAME', cal.name

      cal.event_bookings.each do |booking|
        build_event(ical, booking)
      end

      ical.publish
      ical
    end

    def build_event(ical, booking)
      session = booking.session

      ical.event do |e|
        e.uid         = "#{session.id}@#{Rails.application.config.action_mailer.default_url_options[:host]}"
        e.dtstart     = build_datetime session.start_at
        e.dtend       = build_datetime session.end_at
        e.summary     = session.title
        e.description = session.short_description
        e.location    = session.location
      end
    end

    private

    def build_timezone
      tz = TZInfo::Timezone.get tzid
      tz.ical_timezone Time.current
    end

    def tzid
      'Australia/Melbourne'
    end

    def build_datetime(input)
      Icalendar::Values::DateTime.new input, 'tzid' => tzid
    end
  end
end
