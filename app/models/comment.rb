class Comment < ActiveRecord::Base
  attr_accessible :content, :product_id
  belongs_to :product

  validate :content, presence: true, length: { maximum: 255 }

  def self.loadold(product_id, created_at)
    where("comments.product_id = ? AND comments.created_at < ?", product_id, created_at).order("comments.created_at DESC").limit(10)
  end

  def self.loadnew(product_id)
    where("comments.product_id = ?", product_id).order("comments.created_at DESC").limit(10)
  end
end
