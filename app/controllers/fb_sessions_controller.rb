class FbSessionsController < ApplicationController
	def create_or_login
	 	@fb_token = params[:fb_token]
	 	@graph = Koala::Facebook::API.new(@fb_token)

	 	@profile = @graph.get_object("me")

	 	logger.debug @profile

	 	@id = @profile['id']
	 	@email = @profile['email']
	 	@gender = @profile['gender']
	 	@name = @profile['name']
	 	@seller = false
	 	#@profile_img_path = @graph.get_picture(@id)
	 	
	 	prefix = 'http://graph.facebook.com/'
	 	postfix = '/picture'

		@profile_image = open(prefix + @id + postfix)
	 	@user = User.find_by_fb_id(@id)

	 	#user not exist
	 	if @user.nil?
	 		password = Devise.friendly_token.first(6)
	 		@user = User.create!(:email => @email, :password => password,
	 			:password_confirmation => password, :name => @name,
	 			:gender => @gender, :fb_id => @id, :fb_access_token => @fb_token,
	 			:seller => false, :profile => @profile_image)
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
