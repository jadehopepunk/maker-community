class RenameOrderPriceToTotalPrice < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :order_total, :total_price
    rename_column :orders, :order_tax, :total_tax
  end
end
