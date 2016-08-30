RailsTemplate::Application.routes.draw do
  #get '/', :controller => 'home', :action => 'index'
  get "search_result", :controller => 'home', :action => 'search_result'
  get "home/index"

  resources :user_restaurant_configs

  resources :users

  resources :search_keys

  resources :restaurants

  resources :frequent_sets

  resources :foods

  root :to => 'home#index' 
end
