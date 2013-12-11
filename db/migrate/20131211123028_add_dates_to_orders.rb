class AddDatesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :begin_at, :datetime
    add_column :orders, :end_at, :datetime
  end
end
