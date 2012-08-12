class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price, :categories, :voted, :vote_count, :photolist
  #acts_as_voteable

  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 80 }
  validates :description, presence: true, length: { maximum: 180 }

  def voted
  	User.current.voted_for?(self)
  end

  def vote_count
  	self.plusminus
  end

  def photolist
    self.photos
  end

  # 필요한 virtual attribute를 추가 하는 법[:voted, :something_more, :more...]
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:voted, :vote_count, :photolist])

    #handed 는 voted로 대체 
    options[:except] = :handed
    super options
  end
end
