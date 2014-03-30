class ChangeDurationFormatInJobs < ActiveRecord::Migration
  def up
    change_column :jobs, :duration, :decimal
  end
  def down
    change_column :jobs, :duration, :time
  end
end
