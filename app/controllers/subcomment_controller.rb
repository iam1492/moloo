class SubcommentController < ApplicationController
  before_filter :find_comment, :except => [:list]
  before_filter :authenticate_user!, :except => [:list]

  def create
  	if (@comment.nil?)
  		return
  	end

  	content = params[:content]

	  if (content.nil?)
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false,     
                                                    :message => "content should not empty"}}}
  		end
  	else
		  @subcomment = @comment.subcomments.build(:content => content, :user_id => current_user.id)

  		if @subcomment.save
    		respond_to do |format|
    			format.html
    			format.json {render :json => {:metadata => {:success => true, 
                                                      :message => "succeed to create subcomment"}}}
    		end
    	else
	  		respond_to do |format|
	  			format.html
	  			format.json {render :json => {:metadata => {:success => false,
	                                                    :comment => @comment.errors,
	                                                    :message => "fail to create subcomment"}}}
	  		end
    	end
    end
  end

  def destroy
   	@subcomment = Subcomment.find(params[:id])
  	if @subcomment.destroy
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true,     
                                                    :message => "succeed to delete comment"}}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false, 
                                                    :errors => @comment.errors,
                                                    :message => "fail to delete comment"}}}
  		end
  	end
  end

  private
  def find_comment
  	comment_id = params[:comment_id]
  	if (comment_id.nil?)
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false,     
                                                    :message => "comment_id should not empty"}}}
  		end
  	else
    	@comment = Comment.find(params[:comment_id])
    end
  end
end
