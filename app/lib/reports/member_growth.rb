module Reports
  class MemberGrowth < MonthlyReport
    def result_month(month)
      Tools::ReportRow.new(
        values: [
          Tools::ReportValue.new(month.to_s)
        ]
      )
    end
  end
end
