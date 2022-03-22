module Reports
  class MonthlyReport
    attr_reader :months

    def initialize(start_date, end_date = Date.current)
      @months = Month(start_date)..Month(end_date)
    end

    def each
      row = nil

      months.each do |month|
        row = result_month(month, last_row: row, in_progress: Date.current < month.end_date)
        yield row
      end
    end

    private

    def result_month(*)
      raise NotImplementedError, 'override this'
    end
  end
end
