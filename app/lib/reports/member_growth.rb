module Reports
  class MemberGrowth < MonthlyReport
    def columns
      @columns ||= [
        Tools::MonthColumn.new,
        Tools::Column.new('Concession'),
        Tools::Column.new('Full')
      ]
    end

    def result_month(month)
      plans = ['makerspace-community-concession-member', 'makerspace-community-member']

      Tools::ReportRow.new(
        columns:,
        values: [
          month,
          OrderItem.completed_in_month(month).has_plan_name(['makerspace-community-concession-member']).count(:user_id),
          OrderItem.completed_in_month(month).has_plan_name(['makerspace-community-member']).count(:user_id)
        ]
      )
    end
  end
end
