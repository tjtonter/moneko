class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :user_id
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
