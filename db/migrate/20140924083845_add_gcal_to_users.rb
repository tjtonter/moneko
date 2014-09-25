class AddGcalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gcal, :string
  end
end
