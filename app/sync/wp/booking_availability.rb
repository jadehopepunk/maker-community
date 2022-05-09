module Wp
  class BookingAvailability
    TYPES = ['custom:daterange', 'time:range', 'custom'].freeze
    BOOKABLE_TYPES = ['custom:daterange', 'time:range'].freeze

    def initialize(options = {})
      @type = options['type']
      @bookable = options['bookable'] == 'yes'
      @priority = options['priority']
      @from_time_string = options['from']
      @to_time_string = options['to']
      @from_date_string = options['from_date']
      @to_date_string = options['to_date']
      @max_persons = options[:max_persons]

      raise ArgumentError, "Invalid booking availability type: #{@type}" unless TYPES.include? @type
    end

    def bookable?
      bookable && BOOKABLE_TYPES.include?(type)
    end

    def import_or_update(event)
      session = ::EventSession.where(event:, start_at:).first
      if session
        update_existing(session)
      else
        import_event_session(event)
      end
    end

    def import_event_session(event)
      dest = ::EventSession.new(
        event:,
        start_at:,
        **shared_attributes
      )
      EventSessionService.new.create(dest)
    end

    def update_existing(session)
      session.assign_attributes shared_attributes
      if session.changed?
        session.save!
        puts "updated #{session.class.name}: #{session.id}"
      end
    end

    def shared_attributes
      {
        max_persons: @max_persons,
        end_at:
      }
    end

    def date
      raise 'Multi-date event, not supported' if from_date != to_date

      from_date
    end

    def from_date
      Date.parse(from_date_string)
    rescue TypeError => _e
      puts "invalid date: #{from_date_string} for #{inspect}"
      nil
    end

    def to_date
      Date.parse(to_date_string)
    end

    def from_time
      from_time_string.in_time_zone(Time.zone)
    end

    def to_time
      to_time_string.in_time_zone(Time.zone)
    end

    def start_at
      combine_date_and_time from_date, from_time
    end

    def end_at
      combine_date_and_time to_date, to_time
    end

    private

    attr_reader :type, :bookable, :priority, :from_time_string, :to_time_string, :from_date_string, :to_date_string

    def combine_date_and_time(date, time)
      Time.zone.local(date.year, date.month, date.day, time.hour, time.min, time.sec)
    end
  end
end
