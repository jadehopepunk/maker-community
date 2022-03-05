module Reports
  class MonthlyReport
    attr_reader :months

    def initialize(start_date, end_date = Date.today)
      @months = Month(start_date)..Month(end_date)
    end

    def each
      months.each do |month|
        yield result_month(month)
      end
    end

    private

    def result_month(_month)
      raise NotImplementedError, 'override this'
    end
  end
end
