MolooTemplate::Application.routes.draw do
  get "comments/create"

  get "comments/destory"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  #resources :users, :only => [:show, :index]

  match 'users/list(.format)' => "users#list", :via => :get
  match 'users(.format)' => "users#show", :via => :get
  match 'users/session(.format)' => "sessions#create", :via => :post
  match 'users/session(.format)' => "sessions#destroy", :via => :delete

  match 'products(.format)' => "products#list", :via => :get
  match 'products(.format)' => "products#create", :via => :post
  match 'products/:id(.format)' => "products#show", :via => :get
  match 'products/:id(.format)' => "products#destroy", :via => :delete
  match 'products/:id(.format)' => "products#update", :via => :update  
  match 'products/mylist(.format)' => "products#mylist", :via => :get

  # vote
  match 'products/:id/vote(.format)' => "products#vote", :via => :post
  match 'products/:id/vote(.format)' => "products#unvote", :via => :delete
  match 'products/:id/voters(.format)' => "products#voters", :via => :get

  match 'photos(.format)' => "photos#create", :via => :post
  match 'photos/:id(.format)' => "photos#destroy", :via => :delete

  match 'comments(.format)' => "comments#create", :via => :post
  match 'comments/:id(.format)' => "comments#destroy", :via => :delete

  # get "products/create"
  # get "products/show"
  # get "products/destroy"
  # get "products/update"
end
