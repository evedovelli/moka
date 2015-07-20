class UsersController < ApplicationController
  load_and_authorize_resource :user, :find_by => :username
  before_filter :authenticate_user!, :except => [:show]

  def home
    @user = current_user
    @battles = Battle.all
    @vote = Vote.new()
  end

  def show
    @battles = @user.sorted_battles
    @vote = Vote.new()
  end

end
