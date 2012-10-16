class CommentsController < ApplicationController
  
  before_filter :find_product, :except => [:list]

  def list
    @comment_id = params[:id]
    @product_id = params[:product_id]
    if (@product_id.nil?)
      respond_to do |format|
        format.html
        format.json {render :json => {:metadata => {:success => false, 
                                                    :message => "product_id should not be empty"}
                                      }}
      end
      return
    end

    if (@comment_id.nil?)
      @comments = Comment.loadnew(@product_id)
    else
      @comment = Comment.find_by_id(@comment_id)
      @comments = Comment.loadold(@product_id, @comment.created_at)
    end

    respond_to do |format|
        format.html
        format.json {render :json => {:metadata => {:success => true, 
                                                    :message => "succeed to show product"},
                                      :product_id => @product_id,  
                                      :comments_count => @comments.count,
                                      :comments => @comments }}
    end
  end

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
