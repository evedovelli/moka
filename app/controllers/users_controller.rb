class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:edit, :update, :social, :facebook_friends]
  load_and_authorize_resource :user, :find_by => :username, :except => [:home, :social, :locale, :facebook_friends, :sign_in_popup]

  def locale
    referer_path = URI(request.referer).path
    if /^\/(en|pt-BR)(\/|$|\?)/ =~ referer_path
      redirect_to referer_path.sub(/\/[^\/]+[\/]?/, "/#{I18n.locale}/")
    else
      redirect_to "/#{I18n.locale}#{referer_path}"
    end
  end

  def home
    @user = current_user
    if not @user
      respond_to do |format|
        format.html { render 'users/cover', :layout => "cover" }
      end
      return
    end

    authorize! :home, @user

    @filter = params[:filter] || 'all'

    @battles = Battle.user_home(@user, params[:page])
    @voted_for = current_user.voted_for_options(@battles)
    @victorious = Battle.victorious(@battles)
    @top_comments = Battle.top_comments(@battles)
    @vote = Vote.new()
    @find_friends = true
    @render_welcome = @user.welcome?
    @render_battle_help = @user.first_battle?
    respond_to do |format|
      format.js { render "users/load_more_battles" }
      format.html {}
    end
  end

  def show
    @battles = @user.sorted_battles(params[:page])

    @filter = params[:filter] || 'all'

    @voted_for = {}
    if current_user
      @voted_for = current_user.voted_for_options(@battles)
    end
    @victorious = Battle.victorious(@battles)
    @top_comments = Battle.top_comments(@battles)

    @vote = Vote.new()
    @number_of_following = @user.friends.count
    @number_of_followers = @user.inverse_friends.count
    @render_welcome = @user.welcome?
    @render_battle_help = @user.first_battle?
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
      format.html {}
    end
  end

  def update
    if (not params[:user]) || (not params[:user][:avatar]) || (not @user.update_attributes(:avatar => params[:user][:avatar]))
      flash[:alert] = I18n.t('messages.invalid_image')
    end
    redirect_to user_path(@user)
  end

  def social
    @user = current_user
    authorize! :social, @user
  end

  def facebook_friends
    @user = current_user
    authorize! :facebook_friends, @user

    @users = @user.get_facebook_friends(params[:page])
    @find_friends = true
    respond_to do |format|
      format.js { render('users/index') }
      format.html {}
    end
  end

  def sign_in_popup
    authorize! :sign_in_popup, User
    respond_to do |format|
      format.js {}
      format.html { redirect_to new_user_session_path }
    end
  end
end
