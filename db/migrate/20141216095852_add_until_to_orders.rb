class AddUntilToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :until_at, :date
  end
end
