class AddRuleToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :rule, :text
  end
end
