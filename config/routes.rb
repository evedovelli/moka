Moka::Application.routes.draw do
  filter :locale

  devise_for :users, controllers: {
                                    omniauth_callbacks: "users/omniauth_callbacks",
                                    registrations: "users/registrations"
                                  }

  devise_scope :user do
    get '/users/auth/:provider/battles/:battle_id' => 'users/omniauth_callbacks#share_battle'
    get '/users/auth/:provider/friends' => 'users/omniauth_callbacks#find_friends'
    get '/users/auth/:provider/setup', :to => 'users/omniauth_callbacks#setup'
  end

  get "users/facebook_friends" => "users#facebook_friends", :as => :user_facebook_friends
  get "users/sign_in_popup"    => "users#sign_in_popup",    :as => :user_sign_in_popup
  resources :users, :only => [:show, :index, :edit, :update] do
    resources :friendships, :only => [:create, :destroy, :index]
    resource :email_settings, :only => [:edit, :update]
  end
  get "users/:id/following" => "users#following", :as => :user_following
  get "users/:id/followers" => "users#followers", :as => :user_followers
  get "users/edit/social"   => "users#social",    :as => :user_social

  resources :battles, :except => [:index]
  get "hashtags/:hashtag" => "battles#hashtag", :as => :hashtag
  get "search(/:search)" => "searches#search", :as => :search

  resources :votes, :only => [:create]
  resources :notifications, :only => [:index]
  get "notifications_dropdown" => "notifications#dropdown", :as => :notifications_dropdown

  get "options/:id/votes" => "options#votes", :as => :option_votes

  get '/.well-known/acme-challenge/:id' => 'letsencrypt#challenge'

  get "locale" => 'users#locale', :as => :set_locale

  root :to => "users#home"
end
