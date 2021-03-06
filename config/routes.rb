MolooTemplate::Application.routes.draw do

  get "subcomment/create"

  get "subcomment/destroy"

  get "comments/create"
  get "comments/destory"

  authenticated :user do
    root :to => 'home#index'
  end

  root :to => 'home#index'
  devise_for :users
  #resources :users, :only => [:show, :index]

  match 'users/:id(.format)' => "users#show", :via => :get, :constraints => {:id => /\d+/}
  match 'users(.format)' => "users#list", :via => :get, :as => :user

  match 'users/followings(.format)' => "users#followings", :via => :get
  match 'users/followers(.format)' => "users#followers", :via => :get
  match 'users/:id/follow(.format)' => "users#follow", :via => :post, :constraints => {:id => /\d+/}
  match 'users/:id/unfollow(.format)' => "users#unfollow", :via => :post, :constraints => {:id => /\d+/}

  match 'users/session(.format)' => "sessions#create", :via => :post
  match 'users/session(.format)' => "sessions#destroy", :via => :delete

  match 'products(.format)' => "products#list", :via => :get
  match 'products(.format)' => "products#create", :via => :post
  match 'products/new/(.format)' => "products#new", :via => :get
  match 'products/:id(.format)' => "products#show", :via => :get, :constraints => {:id => /\d+/}
  match 'products/:id(.format)' => "products#destroy", :via => :delete, :constraints => {:id => /\d+/}
  match 'products/:id(.format)' => "products#update", :via => :update, :constraints => {:id => /\d+/}  
  match 'products/my_list(.format)' => "products#my_list", :via => :get
  match 'products/hot_list(.format)' => "products#hot_list", :via => :get
  match 'products/new_list(.format)' => "products#new_list", :via => :get
  match 'products/old_list(.format)' => "products#old_list", :via => :get
  match 'products/picked_list(.format)' => "products#my_picked_list", :via => :get
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  # vote
  match 'products/:id/vote(.format)' => "products#vote", :via => :post, :constraints => {:id => /\d+/}
  match 'products/:id/vote(.format)' => "products#unvote", :via => :delete, :constraints => {:id => /\d+/}
  match 'products/:id/voters(.format)' => "products#voters", :via => :get, :constraints => {:id => /\d+/}

  #comment
  match 'products/:id/comments(.format)' => "products#add_comment", :via => :post, :constraints => {:id => /\d+/}
  match 'comment/:id(.format)' => "comments#destroy", :via => :delete, :constraints => {:id => /\d+/}
  match 'comments(.format)' => "comments#list", :via => :get

  #sub comment
  match 'sub_comments(.format)' => "subcomment#create", :via => :post, :constraints => {:comment_id => /\d+/}
  
  #photo
  match 'products/:id/photos(.format)' => "products#upload_photo", :via => :post, :constraints => {:id => /\d+/}
  match 'photos/:id(.format)' => "photos#destroy", :via => :delete, :constraints => {:id => /\d+/}

  #facebook session
  match 'users/fb/session(.format)' => "fb_sessions#create_or_login", :via => :post

  #facebook friends_search
  match 'users/fb/search(.format)' => "users#fb_friends", :via => :get

end
