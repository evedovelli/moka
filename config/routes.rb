Moka::Application.routes.draw do
  filter :locale

  devise_for :users

  resources :users, :only => [:show, :index, :edit, :update] do
    resources :friendships, :only => [:create, :destroy, :index]
  end
  get "users/:id/following" => "users#following", :as => :user_following
  get "users/:id/followers" => "users#followers", :as => :user_followers

  resources :battles, :except => [:index]
  get "hashtags/:hashtag" => "battles#hashtag", :as => :hashtag
  get "search(/:search)" => "searches#search", :as => :search

  resources :votes, :only => [:create]
  resources :notifications, :only => [:index]
  get "notifications_dropdown" => "notifications#dropdown", :as => :notifications_dropdown

  get "options/:id/votes" => "options#votes", :as => :option_votes

  get '/.well-known/acme-challenge/LZo2V6ot7n7FVSE1zxyOlntTalOlcCiXANi9AY71jVY' => 'letsencrypt#challenge_0'

  root :to => "users#home"
end
