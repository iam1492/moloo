class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price, :handed,
                   :voted, :total_vote, :photolist,
                   :user_email, :user_name, :categories
  acts_as_voteable

  acts_as_taggable
  acts_as_taggable_on :tags

  belongs_to :user
  has_many :photos, dependent: :destroy, :order => "created_at ASC"
  has_many :comments, dependent: :destroy


  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 80 }
  validates :description, presence: true, length: { maximum: 180 }

  def self.loadnew(created_at, is_seller)
    where("products.created_at > ?", created_at).joins("LEFT OUTER JOIN users ON users.id = products.user_id").where("users.seller = ?", is_seller).order("products.created_at ASC").limit(20)
  end

  def self.loadold(created_at, is_seller)
    where("products.created_at < ?", created_at).joins("LEFT OUTER JOIN users ON users.id = products.user_id").where("users.seller = ?", is_seller).order("products.created_at DESC").limit(20)
  end

  def self.loadfirst(is_seller)
    joins("LEFT OUTER JOIN users ON users.id = products.user_id").where("users.seller = ?",is_seller).order("products.created_at DESC").limit(20)
  end

  def self.new_voted_by_user(user_id, created_at)
    @user = User.find(user_id)
    Product.includes("votes").where("products.created_at < ?", created_at).where(:votes => {:voter_id => @user.id,
                                               :voter_type => @user.class.base_class.name, 
                                               :voteable_type => self.base_class.name}).order("products.created_at DESC").limit(20) 
  end

  def self.voted_by_user(user_id)
    @user = User.find(user_id)
    Product.includes("votes").where(:votes => {:voter_id => @user.id,
                                               :voter_type => @user.class.base_class.name, 
                                               :voteable_type => self.base_class.name}).order("products.created_at DESC").limit(20) 
  end
  
  def voted
    if User.current.nil?
      false
    else
  	  User.current.voted_for?(self)
    end
  end

  def total_vote
  	self.plusminus
  end

  def photolist
    self.photos
  end

  def total_comments
    self.comments.count
  end

  def user_email
    @user = User.find(user_id)
    @user.email
  end

  def user_name
    @user = User.find(user_id)
    @user.name
  end

  def seller
    @user = User.find(user_id)
    if @user.seller.nil?
      false
    else
      @user.seller
    end
  end

  def profile_thumbnail_path
    @user = User.find(user_id)
    @user.profile.url(:thumb)
  end

  def categories
    self.tag_list
  end

  # 필요한 virtual attribute를 추가 하는 법[:voted, :something_more, :more...]
  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + 
           [:voted, :total_vote, :photolist, :seller, :total_comments, 
            :user_email, :user_name, :categories,:profile_thumbnail_path])

    #handed 는 voted로 대체 
    options[:except] = :handed
    super options
  end
end
