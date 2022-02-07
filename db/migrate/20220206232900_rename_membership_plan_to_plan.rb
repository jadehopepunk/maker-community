class RenameMembershipPlanToPlan < ActiveRecord::Migration[7.0]
  def change
    rename_table :membership_plans, :plans
    rename_column :memberships, :membership_plan_id, :plan_id
  end
end
