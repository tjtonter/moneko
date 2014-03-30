class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.belongs_to :order
      t.belongs_to :user
      t.decimal :duration
      t.string :description
      t.date :date

      t.timestamps
    end
  end
end
