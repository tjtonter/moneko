class AddRruleHashToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :rrule, :text
  end
end
