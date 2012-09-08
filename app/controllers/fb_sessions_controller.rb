class FbSessionsController < ApplicationController
	def create_or_login
	 	@fb_token = params[:fb_token]
	 	@graph = Koala::Facebook::API.new(@fb_token)

	 	@profile = @graph.get_object("me")
	 	@friends = @graph.get_connections("me", "friends")
	 	

	 	logger.debug @friends.class

	 	@friends_array = []
	 	@friends.each do |friend|
	 		@friends_array << friend['id']
	 	end

	 	logger.debug @friends_array

	 	@id = @profile['id']
	 	@email = @profile['email']
	 	@gender = @profile['gender']
	 	@name = @profile['name']
	 	@seller = false

	 	@user = User.find_by_fb_id(@id)

	 	#user not exist
	 	if @user.nil?
	 		password = Devise.friendly_token.first(6)
	 		User.create!(:email => @email, :password => password,
	 			:password_confirmation => password, :name => @name,
	 			:gender => @gender, :fb_id => @id, :fb_access_token => @fb_token,
	 			:seller => false)
	 	end
	 	if (!@fb_token.eql?@user.fb_access_token)
	 		User.update_attribute(:fb_access_token, @fb_token)
	 	end

	 	@user.ensure_authentication_token!

	 	respond_to do |format|
    		format.html
    		format.json { render :json => { :metadata => {
    								:success => true, 
    								:friends => @friends,
    								:auth_token=>@user.authentication_token}}}

    	end
	end
end
