class Comment < ActiveRecord::Base
  attr_accessible :content, :product_id
  belongs_to :product

  validate :content, presence: true, length: { maximum: 255 }
  
end
