class Photo < ActiveRecord::Base
  attr_accessible :photo
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  belongs_to :product
end
