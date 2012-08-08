class ProductsController < ApplicationController

  before_filter :authenticate_user!

  def list
  	@products = current_user.products
  	respond_to do |format|
  		format.html
  		format.json {render :json => {:metadata => {:success => true}, 
                                    :uid => current_user.id,
                                    :product => @product,
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

  def show
  	@product = current_user.products.find(params[:id])

  	respond_to do |format|
  		format.html
  		format.json {render :json => {:metadata => {:success => true},
                                                  :product => @product,                                                  
                                                  :photos => @product.photos,
                                                  :comments => @product.comments}}
  	end
  end

  def destroy
  	@product = current_user.products.find(params[:id])
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
end
