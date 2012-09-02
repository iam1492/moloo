class ProductsController < ApplicationController

  before_filter :authenticate_user!, :except => [:list, :show, :new_list, :old_list ]
  before_filter :set_current_user

  def my_list
  	@products = current_user.products.paginate(:page => params[:page], :per_page => 10)
  	respond_to do |format|
  		format.html
  		format.json {render :json => {:metadata => {:success => true, :page => params[:page],
                                                  :message => "succeed to list all project",
                                                  :total_count => @products.count},
                                    :product => @products}}
  	end
  end

  def new_list
    @tempproduct = Product.last
    @type_seller = params[:seller]
    if (@type_seller.nil?)
      @type_seller = false
    end

    if (params[:id].nil?)
      @products = Product.loadfirst(@type_seller).reverse

      if (params[:categories] != nil)
        @category_array = params[:categories].split(',').collect!{|t| t.to_s }   
        @products = Product.loadfirst(@type_seller).tagged_with(@category_array)
      end
    else 
      if (params[:categories] != nil)
        @lastproduct = Product.find(params[:id])
        @category_array = params[:categories].split(',').collect!{|t| t.to_s }   
        @products = Product.loadnew(@lastproduct.created_at,@type_seller).tagged_with(@category_array)
      else
        @lastproduct = Product.find(params[:id])
        @products = Product.loadnew(@lastproduct.created_at,@type_seller)
      end
    end
    respond_to do |format|
      format.html
      format.json {render :json => {:metadata => {:success => true,
                                                  :message => "succeed to fetch new products",
                                                  :product_count => @products.count,
                                                  :more_product => has_more_new?(@tempproduct, @products.last)},
                                    :product => @products }}
    end
  end

  # 내가 핸디드한 아이템 리스트 구현 
  # def my_favorite
  #   @products = Product.products.paginate(:page => params[:page], :per_page => 10)
  #   respond_to do |format|
  #     format.html
  #     format.json {render :json => {:metadata => {:success => true, :page => params[:page],
  #                                                 :message => "succeed to list all project",
  #                                                 :total_count => @products.count},
  #                                   :product => @products}}
  #   end
  # end

   def old_list
    @tempproduct = Product.first
    @firstproduct = Product.find(params[:id])
    @type_seller = params[:seller]
    if (@type_seller.nil?)
      @type_seller = false
    end
    
    if (params[:categories] != nil)
      @category_array = params[:categories].split(',').collect!{|t| t.to_s } 
      # degug: to see the category 
      @products = Product.loadold(@firstproduct.created_at, @type_seller).tagged_with(@category_array).reverse
    else
      #@products = Product.where("created_at > '#{@lastuser.created_at}'").limit(20)
      @products = Product.loadold(@firstproduct.created_at, @type_seller).reverse
    end
    respond_to do |format|
      format.html
      format.json {render :json => {:metadata => {:success => true,
                                                  :message => "succeed to fetch old products",
                                                  :product_count => @products.count,
                                                  :more_product => has_more_old?(@tempproduct, @products.first)},
                                    :product => @products }}
    end
  end

  def list

    if (params[:email] != nil)
      logger.debug "find by email"
      @user = User.find_by_email(params[:email])
      @products = @user.products.paginate(:page => params[:page], :per_page => 20)
    elsif (params[:categories] != nil)
      @category_array = params[:categories].split(',').collect!{|t| t.to_s } 
      # degug: to see the category 
      @category_array.each do |t| 
        logger.debug t
      end
      @products = Product.tagged_with(@category_array).paginate(:page => params[:page], :per_page => 20)
    else
      @products = Product.paginate(:page => params[:page], :per_page => 20)
    end
    respond_to do |format|
      format.html
      format.json {render :json => {:metadata => {:success => true, :page => params[:page],
                                                  :message => "succeed to list all project",
                                                  :product_count => @products.count},
                                    :product => @products }}
    end
  end

  def hot_list
    # @products = Product.paginate :page => params[:page], :order => "vote_count DESC"
    # @products = Product.all
    # @products_sorted = @products.sort_by { |item| item.total_vote }.reverse

    @products_sorted = Product.order("handed DESC").paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.json {render :json => {:metadata => {:success => true, :page => params[:page],
                                                  :message => "succeed to list all project",
                                                  :product_count => @products_sorted.count},
                                    :product => @products_sorted }}
    end
  end

  def create
  	name = params[:name]
  	description = params[:description]
  	price = params[:price] || nil
    categories = params[:categories] || nil
  	@product = current_user.products.build(:name => name, :description => :description, :price => price)
    @product.tag_list = categories
  	if @product.save
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true, :message => "succeed to create product"}, :product_id => @product.id}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false, :message => "fail to create product"}}}
  		end
  	end
  end

  #누구나 볼 수 있게
  def show
    @product = Product.find(params[:id])
    if @product.nil?
      format.html
      format.json {render :status=>401, :json => {:metadata => {:success => false, :message => "invalid product id, cannot find any product" }}}
    else
      @photos = @product.photos
      @comments = @product.comments
    	respond_to do |format|
    		format.html
    		format.json {render :json => {:metadata => {:success => true, :message => "succeed to show product", :photo_count => @photos.count, :comment_count => @comments.count },
                                      :product => @product,  
                                      :categories => @product.categories,                                                
                                      :comments => @comments}}
    	end
    end
  end

  #삭제는 해당 upload 유저만 가능
  def destroy
  	@product = current_user.products.find(params[:id])
    if @product.nil?
      respond_to do |format|
        format.html
        format.json {render :json => {:metadata => {:success => true, :message => "fail to find product id:#{params[:id]}"}}}
      end
      return 
    end
  	if @product.destroy
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => true, :message => "product id:#{params[:id]} deleted"}}}
  		end
  	else
  		respond_to do |format|
  			format.html
  			format.json {render :json => {:metadata => {:success => false, :message => "product id#{params[:id]} failed to delete"}}}
  		end
  	end
  end

  def add_comment
    @product = Product.find(params[:id])
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

  def destroy_comment
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

  def update
  end

  def vote
    #@product = current_user.products.find(params[:id])
    @product = Product.find(params[:id])
    if !current_user.voted_on?(@product)
      current_user.vote_for(@product)    

      #save total vote  
      @product.handed = @product.total_vote
      @product.save
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => true, :message => "product id:#{params[:id]} voted"}}}
      end
    else
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => false,:message => "already voted on product id:#{params[:id]}"}}}
      end
    end
  end

  def unvote
    @product = Product.find(params[:id])
    if current_user.voted_on?(@product)
      current_user.unvote_for(@product)   

      #save total vote  
      @product.handed = @product.total_vote
      @product.save   
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => true, :message => "product id:#{params[:id]} unvoted"}}}
      end
    else
      respond_to do |format|
          format.html
          format.json {render :json => {:metadata => {:success => false, :message => "not yet voted on product id:#{params[:id]}"}}}
      end
    end
  end

  def voters
    @product = Product.find(params[:id])
    @users = @product.voters_who_voted
    respond_to do |format|
        format.html
        format.json {render :json => {:metadata => {:success => true, :message => "fetch users vote for product id:#{params[:id]}"},
                                      :user => @users }}
    end    
  end

  def upload_photo
    @product = Product.find(params[:id])
    @photo = @product.photos.build(:photo => params[:photo])
    if @photo.save
      @photo.save
      respond_to do |format|
        format.html
        format.json {render :json => {:metadata => {:success => true}, 
                                      :photo => @photo, 
                                      :product_id => @product.id,
                                      #:photo_url => @photo.photo.url,                                                                      
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

  private
  def is_voted? (_product)
    current_user.voted_on?(_product)
  end

  def has_more_new? (last_item, last_item_loaded)
    if (last_item.nil? || last_item_loaded.nil?)
      return false
    end
    if last_item.id > last_item_loaded.id
      true
    else
      false
    end
  end
  def has_more_old? (first_item, first_item_loaded)
    if (first_item.nil? || first_item_loaded.nil?)
      return false
    end
    if first_item.id < first_item_loaded.id
      true
    else
      false
    end
  end

end
