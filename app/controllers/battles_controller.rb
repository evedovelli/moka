class BattlesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :battle

  def index
    @battles = Battle.all
  end

  def new
    @options = Option.all
    respond_to do |format|
      format.js {}
    end
  end

  def create
    if @battle.save
      respond_to do |format|
        format.js {}
      end
    else
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
    # Ensure to empty the options if none is marked
    params[:battle][:option_ids] ||= []

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
    @total = Vote.where(:battle_id => @battle.id).count
    @results_by_option = @battle.results_by_option
    @results_by_hour = @battle.results_by_hour
  end

end
