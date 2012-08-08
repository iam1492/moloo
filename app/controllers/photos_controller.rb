class PhotosController < ApplicationController
  before_filter :authenticate_user! 
  def create
  	@product = Product.find(params[:product_id])
  	@photo = @product.photos.build(:photo => params[:photo])
    @photo.photo_url = @photo.photo.url
    if @photo.save
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => true}, 
                                      :photo => @photo, 
                                      :product_id => @product.id,                                      
                                      :message => "succeed to create photo"}}
  	  end
    else
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => false}, 
                                      :photo => @photo, 
                                      :product_id => @product.id,
                                      :message => "failed to create photo"}}
  	  end
    end
  end

  def update
    # implement later
  end

  def destroy
  	@photo = Photo.find(params[:id])
  	if @photo.destroy
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => true}, 
                                      :photo => @photo,
                                      :message => "succeed to delete photo"}}
  	  end
    else
      respond_to do |format|
  		  format.html
  		  format.json {render :json => {:metadata => {:success => false}, 
                                      :photo => @photo,
                                      :message => "failed to delete photo"}}
  	  end
    end
  end
end
