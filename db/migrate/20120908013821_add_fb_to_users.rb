class AddFbToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :fb_id, :integer, :limit => 8
  	add_column :users, :gender, :string
  	add_column :users, :fb_access_token, :string
  end
end
