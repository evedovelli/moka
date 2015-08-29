class BattlesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :battle, :except => [:create]

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
    end
  end

  def update
    if params[:battle][:duration] == ""
      params[:battle][:duration] = @battle.duration.to_s
    end
    if params[:battle][:title] == ""
      params[:battle][:title] = @battle.title
    end

    @battle_options_error = ""
    if @battle.update_attributes(params[:battle])
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
      @options_id = "options#{@battle.id}"
      respond_to do |format|
        format.js { render 'battles/reload_update' }
      end
    end
  end

end
