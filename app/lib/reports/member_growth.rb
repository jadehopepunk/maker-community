module Reports
  class MemberGrowth < MonthlyReport
    def columns
      @columns ||= [
        Tools::MonthColumn.new
      ]
    end

    def result_month(month)
      Tools::ReportRow.new(
        columns:,
        values: [
          month
        ]
      )
    end
  end
end
