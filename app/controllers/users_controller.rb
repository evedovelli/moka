class UsersController < ApplicationController
  load_and_authorize_resource :user, :find_by => :username
  before_filter :authenticate_user!, :except => [:show, :following, :followers]

  def home
    @user = current_user
    @battles = Battle.user_home(@user, params[:page])
    @vote = Vote.new()
    respond_to do |format|
      format.js { render "users/load_more_battles" }
      format.html {}
    end
  end

  def show
    @battles = @user.sorted_battles(params[:page])
    @vote = Vote.new()
    @number_of_following = @user.friends.count
    @number_of_followers = @user.inverse_friends.count
    respond_to do |format|
      format.js { render "users/load_more_battles" }
      format.html {}
    end
  end

  def following
    @following = @user.friends
  end

  def followers
    @followers = @user.inverse_friends
  end

end
