class RemoveOrderCurrencyFromOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :order_currency, :string
  end
end
