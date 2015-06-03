Moka::Application.routes.draw do
  filter :locale

  devise_for :users
  get "config" => "users#home", :as => :user_home

  resources :options, :except => [:show, :update, :edit]
  resources :battles do
    resources :votes, :only => [:create]
  end

  root :to => 'votes#new'
end
