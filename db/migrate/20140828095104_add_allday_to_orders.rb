class AddAlldayToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :allday, :boolean
  end
end
