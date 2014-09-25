class AddCustomerToOffer < ActiveRecord::Migration
  def change
    add_reference :offers, :customer, index: true
  end
end
