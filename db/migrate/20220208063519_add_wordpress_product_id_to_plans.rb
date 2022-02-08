class AddWordpressProductIdToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :wordpress_product_id, :integer, allow_nil: true
  end
end
