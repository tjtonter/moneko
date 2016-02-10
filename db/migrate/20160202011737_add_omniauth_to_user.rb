class AddOmniauthToUser < ActiveRecord::Migration
  def up
    add_column :users, :token, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
  end

  def down 
    remove_column :users, :token
    remove_column :users, :uid
    remove_column :users, :provider
  end
end
