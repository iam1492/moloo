class UsersController < ApplicationController
  before_filter :authenticate_user!

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
                                      :products => @user.products,
                                      :following => current_user.following?(@user)}}
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true, :message => "succeed to follow user id:#{params[:id]}"}}}
    end
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html
      format.json { render :json => { :metadata => {:success => true, :message => "succeed to unfollow user id:#{params[:id]}"}}}
    end
  end

end
