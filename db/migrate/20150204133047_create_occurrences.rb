class CreateOccurrences < ActiveRecord::Migration
  def change
    create_table :occurrences do |t|
      t.references :order, index: true
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
