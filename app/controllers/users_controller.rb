class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_current_user

  def list
    #authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.paginate(:page => params[:page])
    logger.debug @users.count
    respond_to do |format|
    	format.html
    	format.json { render :json => { :metadata => {:success => true, :page => params[:page]}, :users => @users}}
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
    	format.html
    	format.json { render :json => { :metadata => {:success => true},
                                      :users => @user}}
    end
  end

  def followings
    if (params[:email].nil?)
      @following_users = current_user.followed_users
    else
      @user = User.find_by_email(params[:email])
      @following_users = @user.followed_users
    end
    if (@following_users.length == 0)
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => false, 
                                                    :message => "no following user found", 
                                                    :total_count => @following_users.length}}}
      end
      return
    end  
    if @following_users != nil
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true, 
                                                    :message => "succeed to fetch following users", 
                                                    :total_count => @following_users.length},
                                      :users => @following_users}}
      end
    end
  end

  def fb_friends

    if (current_user.fb_access_token.nil?)
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => false,
                                      :message => "not authenticated by facebook"}}}
      end
    end

    @graph = Koala::Facebook::API.new(current_user.fb_access_token)
    @friends = @graph.get_connections("me", "friends")

    @friends_array = []

    @friends.each do |friend|
      @friends_array << friend['id']
    end

    logger.debug @friends_array

    if (@friends_array != nil && @friends_array.length > 0)
      @fb_friends = User.find_all_by_fb_id(@friends_array)
    else
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => false,
                                      :message => "no facebook friends found"}}}
      end
    end

    if (@fb_friends != nil && @fb_friends.length > 0)
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true,
                                      :message => "succeed to fetch following users", 
                                      :total_count => @fb_friends.length},
                                      :users => @fb_friends}}
      end
    else
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true,
                                      :message => "no user found",
                                      :total_count => 0}}}
      end
    end
  end

  def followers
    if (params[:email].nil?)
      @follower_users = current_user.followers
    else
      @user = User.find_by_email(params[:email])
      @follower_users = @user.followers
    end

    if (@follower_users.length == 0)
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => false, 
                                                    :message => "no follower user found", 
                                                    :total_count => @follower_users.length}}}
      end
      return
    end  
    if @follower_users != nil
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true,
                                      :message => "succeed to fetch following users", 
                                      :total_count => @follower_users.length},
                                      :users => @follower_users}}
      end
    end
  end

  #follow user /users/:id/follow
  def follow
    @user = User.find(params[:id])
    if (@user.nil?)
      respond_to do |format|
        format.html
        format.json { render :json => { :metadata => {:success => false, 
                                                      :message => "fails to find user with user id#{params[:id]}"}}}
      end
      return
    end

    if current_user.following? @user
      respond_to do |format|
        format.html
        format.json { render :json => { :metadata => {:success => false, 
                                                      :message => "already follow user with user id#{params[:id]}"}}}
      end
      return
    end

    if (@user.email == current_user.email)
      respond_to do |format|
        format.html
        format.json { render :json => { :metadata => {:success => false, 
                                                      :message => "cannot follow to self"}}}
      end
      return
    end
    current_user.follow!(@user)
    respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true, 
                                                    :message => "succeed to follow user id:#{params[:id]}"}}}
    end
  end

  #follow user /users/:id/unfollow
  def unfollow
    @user = User.find(params[:id])

    if (@user.nil?)
      respond_to do |format|
        format.html
        format.json { render :json => { :metadata => {:success => false, 
                                                      :message => "fails to find user with user id#{params[:id]}"}}}
      end
      return
    end

    if not current_user.following? @user
      respond_to do |format|
        format.html
        format.json { render :json => { :metadata => {:success => false, 
                                                      :message => "already unfollow user with user id#{params[:id]}"}}}
      end
      return
    end

    if (@user.email == current_user.email)
      respond_to do |format|
        format.html
        format.json { render :json => { :metadata => {:success => false, 
                                                      :message => "cannot unfollow to self"}}}
      end
      return
    end

    current_user.unfollow!(@user)
    respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true, 
                                                    :message => "succeed to unfollow user id:#{params[:id]}"}}}
    end
  end
end
