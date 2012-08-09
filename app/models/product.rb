class Product < ActiveRecord::Base
  attr_accessible :description, :handed, :name, :price, :categories

  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 80 }
  validates :description, presence: true, length: { maximum: 180 }
 
end
