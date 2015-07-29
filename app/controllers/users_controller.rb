class UsersController < ApplicationController
  load_and_authorize_resource :user, :find_by => :username
  before_filter :authenticate_user!, :except => [:show]

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
    respond_to do |format|
      format.js { render "users/load_more_battles" }
      format.html {}
    end
  end

end
