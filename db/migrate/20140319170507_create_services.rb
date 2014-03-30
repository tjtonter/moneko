class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :title
      t.decimal :price
      t.references :offer, index: true

      t.timestamps
    end
  end
end
