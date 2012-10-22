class Comment < ActiveRecord::Base
  attr_accessible :content, :product_id, :user_id
  belongs_to :product
  has_many :subcomments

  validate :content, presence: true, length: { maximum: 255 }
  validate :product_id, presence: true

  def self.loadold(product_id, created_at)
    where("comments.product_id = ? AND comments.created_at < ?", product_id, created_at).order("comments.created_at DESC").limit(10)
  end

  def self.loadnew(product_id)
    where("comments.product_id = ?", product_id).order("comments.created_at DESC").limit(10)
  end

  def user_email
  	if (self.user_id.nil?)
  		"no@email.com"
  		return
  	end
    @user = User.find(self.user_id)
    @user.email
  end

  def user_name
  	if (self.user_id.nil?)
  		"no user name"
  		return
  	end
    @user = User.find(self.user_id)
    @user.name
  end

  def profile_thumbnail_path
  	if (self.user_id.nil?)
  		"missing.png"
  		return
  	end
    @user = User.find(user_id)
    @user.profile.url(:thumb)
  end

  def sub_comments
    self.subcomments
  end

  def sub_comments_count

    if (self.subcomments.nil?)
      @count = 0
    else
      @count = self.subcomments.count
    end
    @count
  end

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + 
           [:user_email, :user_name,:profile_thumbnail_path,
            :sub_comments, :sub_comments_count])
    super options
  end
end
