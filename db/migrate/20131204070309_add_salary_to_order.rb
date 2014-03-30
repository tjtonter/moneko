class AddSalaryToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :salary, :decimal
  end
end
