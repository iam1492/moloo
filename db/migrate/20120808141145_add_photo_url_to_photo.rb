class AddPhotoUrlToPhoto < ActiveRecord::Migration
  def change
  	add_column :photos, :photo_url, :string
  end
end
