Moka::Application.routes.draw do
  filter :locale

  devise_for :users
  get "config" => "users#home", :as => :user_home

  resources :battles
  resources :votes, :only => [:create]

  root :to => 'votes#new'
end
