class CreateReportEntries < ActiveRecord::Migration
  def change
    create_table :report_entries do |t|
      t.references :user_id
      t.references :order_id
      t.datetime :date
      t.decimal :salary
      t.timestamps
    end
  end
end
