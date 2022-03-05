module Reports
  class MemberGrowth < MonthlyReport
    def columns
      @columns ||= [
        Tools::MonthColumn.new,
        Tools::Column.new('Concession'),
        Tools::Column.new('Full'),
        Tools::Column.new('Total'),
        Tools::ChangeColumn.new('Growth', column_index: 3)
      ]
    end

    def result_month(month, last_row: nil)
      concession = orders_for(month, 'makerspace-community-concession-member')
      full = orders_for(month, 'makerspace-community-member')

      Tools::ReportRow.new(
        columns:,
        values: [
          month,
          concession,
          full,
          concession + full,
          nil
        ],
        last_row:
      )
    end

    private

    def orders_for(month, plan_name)
      OrderItem.completed_in_month(month).has_plan_name([plan_name]).count(:user_id)
    end
  end
end
