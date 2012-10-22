class Subcomment < ActiveRecord::Base
  attr_accessible :comment_id, :content, :user_id
  belongs_to :comment

  validate :content, presence: true, length: { maximum: 255 }
  validate :comment_id, presence: true

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

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + 
           [:user_email, :user_name,:profile_thumbnail_path])
    super options
  end  
end
