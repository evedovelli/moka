class BattlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :battle, :except => [:create]

  def index
    @battles = Battle.all
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
      format.html { render 'new' }
    end
  end

  def create
    params[:battle]["starts_at"] = DateTime.now
    if params[:battle][:duration] == ""
      params[:battle][:duration] = (24*60).to_s
    end

    @battle = Battle.new(params[:battle])
    authorize! :create, @battle

    @battle_options_error = ""
    if @battle.save
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
    @battle.destroy
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

    @battle_options_error = ""
    if @battle.update_attributes(params[:battle])
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

  def show
    @total = @battle.votes.count
    @results_by_option = @battle.results_by_option
    @results_by_hour = @battle.results_by_hour
  end

end
