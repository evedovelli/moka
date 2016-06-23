class BattlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :hashtag]
  load_and_authorize_resource :battle, :except => [:create, :hashtag]

  def show
    @vote = Vote.new()
    if current_user
      @voted_for = current_user.voted_for_options([@battle])
    else
      @voted_for = nil
    end
    @victorious = Battle.victorious([@battle])
  end

  def new
    2.times do
      @battle.options.build
    end
    @battle.duration = 24*60
    @battle_options_error = ""
    @options_id = "options_new"
    respond_to do |format|
      format.js {}
    end
  end

  def create
    @battle_options_error = ""

    if not params[:battle]
      @options_id = "options_new"
      respond_to do |format|
        format.js { render 'battles/reload_form' }
      end
      return
    end

    params[:battle]["starts_at"] = DateTime.now
    if (not params[:battle][:duration]) || (params[:battle][:duration] == "")
      params[:battle][:duration] = (24*60).to_s
    end
    if (not params[:battle][:title]) || (params[:battle][:title] == "")
      params[:battle][:title] = I18n.t('battles.default_title')
    end
    params[:battle][:user] = current_user

    @battle = Battle.new(params[:battle])
    authorize! :create, @battle

    @battle.fetch_hashtags

    if @battle.save
      @vote = Vote.new()
      respond_to do |format|
        format.js {}
      end
    else
      if @battle.errors.any?
        if @battle.errors.messages.has_key?(:options)
          @battle_options_error = "battle-options-error"
        end
      end
      @options_id = "options_new"
      respond_to do |format|
        format.js { render 'battles/reload_form' }
      end
    end
  end

  def destroy
    @battle_id = @battle.id
    @battle.hashtag_list = nil
    @battle.hide
    respond_to do |format|
      format.js {}
    end
  end

  def edit
    @battle_options_error = ""
    @options_id = "options#{@battle.id}"
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def update
    if params[:battle][:duration] == ""
      params[:battle][:duration] = @battle.duration.to_s
    end
    if params[:battle][:title] == ""
      params[:battle][:title] = @battle.title
    end

    @battle.fetch_hashtags

    @battle_options_error = ""
    if @battle.update_attributes(params[:battle])
      @vote = Vote.new()
      @voted_for = current_user.voted_for_options([@battle])
      respond_to do |format|
        format.js {}
      end
    else
      if @battle.errors.any?
        if @battle.errors.messages.has_key?(:options)
          @battle_options_error = "battle-options-error"
        end
      end
      @options_id = "options#{@battle.id}"
      respond_to do |format|
        format.js { render 'battles/reload_update' }
      end
    end
  end

  def hashtag
    authorize! :hashtag, Battle

    @hashtag = params[:hashtag]
    if (@hashtag) && (@hashtag != "")
      @search = @hashtag
      @hashtag_counts = Battle.hashtag_usage(@hashtag)

      @battles = Battle.with_hashtag(@hashtag, params[:page])

      @filter = params[:filter] || 'all'

      if current_user
        @voted_for = current_user.voted_for_options(@battles)
      else
        @voted_for = nil
      end
      @victorious = Battle.victorious(@battles)
      @vote = Vote.new()

      respond_to do |format|
        format.js { render "users/load_more_battles" }
        format.html {}
      end
    else
      flash[:alert] = I18n.t('messages.invalid_search')
      redirect_to root_url
    end
  end
end
