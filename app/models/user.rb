class User < ActiveRecord::Base
  acts_as_voter
	rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable
  before_save :ensure_authentication_token

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation,
             :remember_me, :authentication_token, :seller, :profile,
             :fb_access_token, :fb_id, :gender
  has_many :products, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_attached_file :profile, :styles => {:medium => "480x480", :thumb => "100x100"}

  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end

  def following?(other_user)
    if relationships.find_by_followed_id(other_user.id).nil?
      false
    else
      true
    end
  end

  def following
    if User.current.following?(self)
      true
    else
      false
    end
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user).destroy
  end

  def following_count
    self.followed_users.count
  end

  def follower_count
    self.followers.count
  end

  def product_count
    self.products.count
  end

  def voted_count
    self.vote_count :up
  end

  def profile_thumbnail_path
    self.profile.url(:thumb)
  end

  def profile_medium_path
    self.profile.url(:medium)   
  end

  def is_seller
    if self.seller.nil?
      false
    else
      self.seller
    end
  end

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + 
           [:following_count, :follower_count, :product_count, 
            :voted_count,:profile_thumbnail_path, :profile_medium_path,
            :is_seller, :following])

    #handed 는 voted로 대체 
    #options[:except] = :user_id
    super options
  end
end
