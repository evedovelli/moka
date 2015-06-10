class BattlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :battle

  def index
    @battles = Battle.all
  end

  def new
    2.times do
      @battle.options.build
    end
    @battle_options_error = ""
    respond_to do |format|
      format.js {}
    end
  end

  def create
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
      @options = Option.all
      respond_to do |format|
        format.js { render 'reload_form' }
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
    @options = Option.all
    respond_to do |format|
      format.js {}
    end
  end

  def update
    if @battle.update_attributes(params[:battle])
    respond_to do |format|
        format.js {}
      end
    else
      @options = Option.all
      respond_to do |format|
        format.js { render 'reload_update' }
      end
    end
  end

  def show
    @total = @battle.votes.count
    @results_by_option = @battle.results_by_option
    @results_by_hour = @battle.results_by_hour
  end

end
