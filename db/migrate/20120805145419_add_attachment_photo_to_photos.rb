class AddAttachmentPhotoToPhotos < ActiveRecord::Migration
  def self.up
    change_table :photos do |t|
      t.has_attached_file :photo
    end
  end

  def self.down
    drop_attached_file :photos, :photo
  end
end
