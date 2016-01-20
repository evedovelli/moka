class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update]
  load_and_authorize_resource :user, :find_by => :username

  def home
    @user = current_user
    if not @user
      respond_to do |format|
        format.html { render 'users/cover', :layout => "cover" }
      end
      return
    end

    @battles = Battle.user_home(@user, params[:page])
    @voted_for = current_user.voted_for_options(@battles)
    @victorious = Battle.victorious(@battles)
    @vote = Vote.new()
    respond_to do |format|
      format.js { render "users/load_more_battles" }
      format.html {}
    end
  end

  def show
    @battles = @user.sorted_battles(params[:page])

    @voted_for = {}
    if current_user
      @voted_for = current_user.voted_for_options(@battles)
    end
    @victorious = Battle.victorious(@battles)

    @vote = Vote.new()
    @number_of_following = @user.friends.count
    @number_of_followers = @user.inverse_friends.count
    respond_to do |format|
      format.js { render "users/load_more_battles" }
      format.html {}
    end
  end

  def index
    @search = params[:search] || session[:user_search]
    if (@search) && (@search != "")
      session[:user_search] = @search
      @users = User.search(@search, params[:page])
      respond_to do |format|
        format.js {}
        format.html {}
      end
    else
      flash[:alert] = I18n.t('messages.invalid_search')
      redirect_to root_url
    end
  end

  def following
    @users = @user.following(params[:page])
    respond_to do |format|
      format.js { render('users/index') }
      format.html {}
    end
  end

  def followers
    @users = @user.followers(params[:page])
    respond_to do |format|
      format.js { render('users/index') }
      format.html {}
    end
  end

  def edit
    respond_to do |format|
      format.js {}
    end
  end

  def update
    if (not params[:user]) || (not params[:user][:avatar]) || (not @user.update_attributes(:avatar => params[:user][:avatar]))
      flash[:alert] = I18n.t('messages.invalid_image')
    end
    redirect_to user_path(@user)
  end

end
