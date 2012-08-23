class AddMetaToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :photo_meta,    :text
  end

  def self.down
    remove_column :photos, :photo_meta
  end
end
