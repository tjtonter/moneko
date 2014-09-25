class AddGcalidToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :gcalid, :string
  end
end
