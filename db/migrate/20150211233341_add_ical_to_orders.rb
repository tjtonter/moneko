class AddIcalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ical, :string
  end
end
