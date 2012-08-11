class ProductsController < ApplicationController

  before_filter :authenticate_user!, :except => [:list, :show ]
  before_filter :set_current_user

  def mylist
  	@products = current_user.products
  	respond_to do |format|
  		format.html
  		format.json {render :json => {:metadata => {:success => true}, 
                                    # :uid => current_user.id,
                                    :product => @product,                                                                
                                    :message => "succeed to list all project"}}
  	end
  end

  def list
    @products = Product.paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.json {render :json => {:metadata => {:success => true}, 
                                    # :uid => current_user.id,
                                    :product => @products, 
                                    :page => params[:page],                                                                         
                                    :message => "succeed to list all project"}}
    end
  end

  def create

  	name = params[:name]
  	description = params[:description]
  	price = params[:price] || nil

  	@product = current_user.products.build(:name => name, :description => :description, :price => price)

  	if @product.save
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true},     
                                                    :product => @product,
                                                    :message => "succeed to create product"}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false}, 
                                                    :product => @product.errors,
                                                    :message => "fail to create product"}}
  		end
  	end
  end

  #누구나 볼 수 있게
  def show
  	#@product = current_user.products.find(params[:id])
    @product = Products.find(params[:id])
  	respond_to do |format|
  		format.html
  		format.json {render :json => {:metadata => {:success => true},
                                                  :product => @product,                                                  
                                                  :photos => @product.photos,
                                                  :comments => @product.comments}}
  	end
  end

  #삭제는 해당 upload 유저만 가능
  def destroy
  	@product = current_user.products.find(params[:id])
    #@product = Products.find(params[:id])
  	if @product.destroy
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true},
                                      :product => @product, 
                                      :message => "product id:#{params[:id]} deleted"}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false}, 
                                                    :product => @product, 
                                                    :message => "product id#{params[:id]} failed to delete"}}
  		end
  	end
  end

  def update
  end

  def vote
    #@product = current_user.products.find(params[:id])
    @product = Product.find(params[:id])
    if !current_user.voted_on?(@product)
      current_user.vote_for(@product)      
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => true},
                                        :product => @product, 
                                        :message => "product id:#{params[:id]} voted"}}
      end
    else
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => false},
                                        :product => @product, 
                                        :message => "already voted on product id:#{params[:id]}"}}
      end
    end
  end

  def unvote
    @product = Product.find(params[:id])
    if current_user.voted_on?(@product)
      current_user.unvote_for(@product)      
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => true},
                                        :product => @product, 
                                        :message => "product id:#{params[:id]} unvoted"}}
      end
    else
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => false},
                                        :product => @product, 
                                        :message => "not yet voted on product id:#{params[:id]}"}}
      end
    end
  end

  def voters
    @product = Product.find(params[:id])
    @users = @product.voters_who_voted
    respond_to do |format|
        format.html
        format.json {render :json => {:metadata => {:success => true},
                                      :user => @users, 
                                      :message => "fetch users vote for product id:#{params[:id]}"}}
    end    
  end

  private
  def is_voted? (_product)
    current_user.voted_on?(_product)
  end
end
