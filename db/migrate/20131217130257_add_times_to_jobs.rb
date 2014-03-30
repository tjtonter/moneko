class AddTimesToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :begin, :time
    add_column :jobs, :end, :time
  end
end
