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
                                      :users => @user, 
                                      #:products => @user.products,
                                      :following => current_user.following?(@user)}}
    end
  end

  def followings
    @following_users = current_user.followed_users
    if @following_users != nil
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true},
                                      :users => @following_users}}
      end
    end
  end

  def followers
    @follower_users = current_user.followers
    if @follower_users != nil
      respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true},
                                      :users => @follower_users}}
      end
    end
  end

  #follow user /users/:id/follow
  def follow
    @user = User.find(params[:id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true, :message => "succeed to follow user id:#{params[:id]}"}}}
    end
  end

  #follow user /users/:id/unfollow
  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true, :message => "succeed to unfollow user id:#{params[:id]}"}}}
    end
  end

end
