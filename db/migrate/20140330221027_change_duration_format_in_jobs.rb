class ChangeDurationFormatInJobs < ActiveRecord::Migration
  change_column :jobs, :duration, :decimal, precision: 8, scale: 2
end
