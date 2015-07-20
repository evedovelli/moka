Moka::Application.routes.draw do
  filter :locale

  devise_for :users

  resources :users, :only => [:show]

  resources :battles, :except => [:index, :show]
  resources :votes, :only => [:create]

  root :to => "users#home"
end
