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

      raise ArgumentError, "Invalid booking availability type: #{@type}" unless TYPES.include? @type
    end

    def bookable?
      bookable && BOOKABLE_TYPES.include?(type)
    end

    def import_event_session_if_new(event)
      session = ::EventSession.where(event:, start_at:).first
      session || import_event_session(event)
    end

    def import_event_session(event)
      dest = ::EventSession.create!(
        event:,
        start_at:,
        end_at:
      )
      puts "imported event session #{event.slug}, #{start_at}"
      dest
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
      Time.parse(from_time_string)
    end

    def to_time
      Time.parse(to_time_string)
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
      DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec, time.zone)
    end
  end
end
