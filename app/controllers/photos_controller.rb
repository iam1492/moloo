class PhotosController < ApplicationController
  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
  end
 
  def new
    @photo = Photo.new
  end
 
  def create
  	@product = Product.find(params[:product_id])
  	@photo = @product.photos.build(params[:photo])
    #@photo = Photo.new(params[:photo])
    if @photo.save
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => true}, :photo => @photo, :product_id => @product.id}}
  	  end
    else
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => false}, :photo => @photo, :product_id => @product.id}}
  	  end
    end
  end
 
  def edit
    @photo = Image.find(params[:id])
  end
 
  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      redirect_to @photo
    end
  end

  def destroy
  	@photo = Photo.find(params[:id])
  	if @photo.destroy
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => true}, :photo => @photo}}
  	  end
    else
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => false}, :photo => @photo}}
  	  end
    end
  end
end
