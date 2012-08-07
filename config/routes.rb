MolooTemplate::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  #resources :users, :only => [:show, :index]

  match 'users(.format)' => "users#index", :via => :get
  match 'users/:id(.format)' => "users#show", :via => :get
  match 'users/log_in(.format)' => "sessions#create", :via => :post
  match 'users/log_out(.format)' => "sessions#destroy", :via => :delete


  match 'products(.format)' => "products#list", :via => :get
  match 'products(.format)' => "products#create", :via => :post
  match 'products/:id(.format)' => "products#show", :via => :get
  match 'products/:id(.format)' => "products#destroy", :via => :delete
  match 'products/:id(.format)' => "products#update", :via => :update

  match 'photos(.format)' => "photos#create", :via => :post
  match 'photos/:id(.format)' => "photos#destroy", :via => :delete
  # get "products/create"
  # get "products/show"
  # get "products/destroy"
  # get "products/update"
end
