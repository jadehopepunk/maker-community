module Wp
  class BookingDurationFixed
    class StringTime
      attr_reader :hours, :minutes

      def initialize(time_string)
        raise ArgumentError if time_string.blank?

        @hours, @minutes = time_string.split(':').map(&:to_i)
      end

      def add_hours(delta)
        @hours += delta
      end

      def add_minutes(delta)
        @minutes += delta
        while @minutes >= 60
          @hours += 1
          @minutes -= 60
        end
      end

      def >=(other)
        hours > other.hours || (hours == other.hours && minutes >= other.minutes)
      end

      def <=(other)
        hours < other.hours || (hours == other.hours && minutes <= other.minutes)
      end

      def to_s
        [format('%02d', @hours), format('%02d', @minutes)].join(':')
      end
    end

    attr_reader :amount, :unit

    def initialize(amount, unit)
      @amount = amount
      @unit = unit
    end

    def build_availabilities(params)
      if params['from'].blank? || params['to'].blank? || !params['from'].include?(':')
        return Wp::BookingAvailability.new(params)
      end

      from = StringTime.new(params['from'])
      to = StringTime.new(params['to'])
      original_to = to.clone
      limit_amount = 20

      result = []

      for index in 1..limit_amount
        to = add_amount(from.clone)

        result << Wp::BookingAvailability.new(params.merge('from' => from.to_s, 'to' => to.to_s)) if to <= original_to

        break if to >= original_to

        from = to.clone
      end

      result
    end

    private

    def add_amount(time)
      case unit
      when 'hour'
        time.add_hours(amount)
      when 'minute'
        time.add_minutes(amount)
      else
        raise "Unknown unit: #{unit}"
      end
      time
    end
  end
end
