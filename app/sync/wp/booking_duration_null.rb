module Wp
  class BookingDurationNull
    def build_availabilities(params)
      Wp::BookingAvailability.new(params)
    end
  end
end
