class AddGoogleIdToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :gid, :string
  end

  def down
    remove_column :orders, :gid
  end
end
