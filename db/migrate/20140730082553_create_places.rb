class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.text :address
      t.references :customer, index: true

      t.timestamps
    end
  end
end
