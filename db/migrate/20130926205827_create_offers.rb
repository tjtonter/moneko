class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.text :customer
      t.string :target
      t.text :contents
      t.text :execution
      t.text :delivery
      t.text :charge

      t.timestamps
    end
  end
end
