module VirtualEvents
  class VirtualEventSession
    attr_reader :date, :start_time, :end_time, :event

    def initialize(event, date, start_time, end_time)
      @date = date
      @start_time = start_time
      @end_time = end_time
      @event = event
    end

    delegate :title, :string_identifier, to: :event

    def image
      nil
    end

    def start_at
      combine_date_and_time date, start_time
    end

    def end_at
      combine_date_and_time date, end_time
    end

    def string_identifier
      start_at.to_s
    end

    def find_or_create_session(event)
      event.sessions.where(start_at:).first || create_session(event)
    end

    def create_session(event)
      event.sessions.create!(start_at:, end_at:)
    end

    private

    def combine_date_and_time(date, time)
      DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec)
    end
  end
end
