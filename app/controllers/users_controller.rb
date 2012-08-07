class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    #authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.paginate(:page => params[:page])
    respond_to do |format|
    	format.html
    	format.json { render :json => { :metadata => {:success => true, :page => params[:page]}, :users => @user}}
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
    	format.html
    	format.json { render :json => { :metadata => {:success => true}, :users => @user, :products => @user.products}}
    end
  end
end
