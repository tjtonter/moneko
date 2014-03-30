class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :title
      t.text :description
      t.references :offer, index: true

      t.timestamps
    end
  end
end
