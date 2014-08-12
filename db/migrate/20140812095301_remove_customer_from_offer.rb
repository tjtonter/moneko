class RemoveCustomerFromOffer < ActiveRecord::Migration
  def change
    remove_column :offers, :customer, :string
  end
end
