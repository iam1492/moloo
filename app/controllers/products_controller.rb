class ProductsController < ApplicationController

  before_filter :authenticate_user!

  def list
  	@products = current_user.products
	respond_to do |format|
		format.html
		format.json {render :json => {:metadata => {:success => true}, :product => @product}}
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
  			format.json {render :json => {:metadata => {:success => true}, :product => @product}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false}, :product => @product.errors}}
  		end
  	end
  end

  def show
  	@product = current_user.products.find(params[:id])
	respond_to do |format|
		format.html
		format.json {render :json => {:metadata => {:success => true}, :product => @product, :page => params[:page]}}
	end
  end

  def destroy
  	@product = current_user.products.find(params[:id])
  	if @product.destroy
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true}, :product => @product, :message => "product id:#{params[:id]} deleted"}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false}, :product => @product, :message => "product id#{params[:id]} failed to delete"}}
  		end
  	end
  end

  def update
  end
end
