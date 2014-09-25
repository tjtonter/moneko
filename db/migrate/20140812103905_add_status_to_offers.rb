class AddStatusToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :status, :string
    add_index :offers, :status
  end
end
