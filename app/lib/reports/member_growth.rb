module Reports
  class MemberGrowth < MonthlyReport
    def columns
      @columns ||= [
        Tools::MonthColumn.new,
        Tools::NumberColumn.new('Concession'),
        Tools::NumberColumn.new('Full'),
        Tools::NumberColumn.new('Total'),
        Tools::ChangeColumn.new('Growth', column_index: 3)
      ]
    end

    def result_month(month, last_row: nil, in_progress: false)
      concession = orders_for(month, :community_concession_member)
      full = orders_for(month, :community_member)

      Tools::ReportRow.new(
        columns:,
        classes: [in_progress ? 'in-progress' : nil],
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
