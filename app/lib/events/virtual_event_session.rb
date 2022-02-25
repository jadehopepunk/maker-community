module Events
  class VirtualEventSession
    attr_reader :date, :start_time, :end_time, :event

    def initialize(event, date, start_time, end_time)
      @date = date
      @start_time = start_time
      @end_time = end_time
      @event = event
    end

    def image
      nil
    end

    def start_at
      combine_date_and_time date, start_time
    end

    private

    def combine_date_and_time(date, time)
      DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec)
    end
  end
end
