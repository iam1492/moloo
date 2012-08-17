class CommentsController < ApplicationController
  
  before_filter :find_product

  def create
  	#@product = Product.find(params[:product_id])

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
  	@comment = Comment.find(params[:id])
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

  private
  def find_product
    @product = Product.find(params[:product_id])
  end
end
