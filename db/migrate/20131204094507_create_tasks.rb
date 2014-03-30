class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true
      t.references :order, index: true
      t.datetime :task_date

      t.timestamps
    end
  end
end
