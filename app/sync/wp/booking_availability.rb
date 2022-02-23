module Wp
  class BookingAvailability
    TYPES = ['custom:daterange', 'time:range', 'custom'].freeze

    def initialize(options = {})
      @type = options['type']
      @bookable = options['bookable']
      @priority = options['priority']
      @from = options['from']
      @to = options['to']
      @from_date = options['from_date']
      @to_date = options['to_date']

      raise ArgumentError, "Invalid booking availability type: #{@type}" unless TYPES.include? @type
    end
  end
end
