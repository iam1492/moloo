class Photo < ActiveRecord::Base
  attr_accessible :photo, :photo_url, :photo_path, :photo_thumbnail_path, :photo_medium_path
  has_attached_file :photo, :styles => { :medium => "720x", :thumb => "100x100>" }
  belongs_to :product

  def photo_path
  	self.photo.url
  end

  def photo_thumbnail_path
  	self.photo.url(:thumb)
  end

  def photo_medium_path
  	self.photo.url(:medium)  	
  end

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:photo_path, :photo_thumbnail_path, :photo_medium_path])

    #handed 는 voted로 대체 
    options[:except] = ((options[:except] || []) + [:updated_at, :product_id, :photo_url, 
                                                    :photo_file_name, :photo_file_size, 
                                                    :photo_content_type, :photo_updated_at])
    super options
  end
end
