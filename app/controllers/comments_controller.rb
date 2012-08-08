class CommentsController < ApplicationController
  def create
  	@product = Product.find(params[:product_id])
  	@comment = @product.comments.build(:content => params[:content])
  	if @comment.save
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true},     
                                                    :comment => @comment,
                                                    :message => "succeed to create comment"}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false}, 
                                                    :comment => @comment.errors,
                                                    :message => "fail to create comment"}}
  		end
  	end
  end

  def destroy
  	@product = Product.find(:product_id)
  	@comment = @product.comments.find(params[:id])
  	if @comment.destroy
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true},     
                                                    :comment => @comment,
                                                    :message => "succeed to delete comment"}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false}, 
                                                    :comment => @comment.errors,
                                                    :message => "fail to delete comment"}}
  		end
  	end
  end
end
