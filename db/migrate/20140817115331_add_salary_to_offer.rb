class AddSalaryToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :salary, :integer
  end
end
