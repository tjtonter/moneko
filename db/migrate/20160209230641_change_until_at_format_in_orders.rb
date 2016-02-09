class ChangeUntilAtFormatInOrders < ActiveRecord::Migration
  def up
    change_column :orders, :until_at, :datetime
  end

  def down
    change_column :orders, :until_at, :date
  end
end
