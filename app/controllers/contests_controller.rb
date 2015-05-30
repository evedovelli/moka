class ContestsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :contest

  def index
    @contests = Contest.all
  end

  def new
    @stuffs = Stuff.all
    respond_to do |format|
      format.js {}
    end
  end

  def create
    if @contest.save
      respond_to do |format|
        format.js {}
      end
    else
      @stuffs = Stuff.all
      respond_to do |format|
        format.js { render 'reload_form' }
      end
    end
  end

  def destroy
    @contest_id = @contest.id
    @contest.destroy
    respond_to do |format|
      format.js {}
    end
  end

  def edit
    @stuffs = Stuff.all
    respond_to do |format|
      format.js {}
    end
  end

  def update
    # Ensure to empty the stuffs if none is marked
    params[:contest][:stuff_ids] ||= []

    if @contest.update_attributes(params[:contest])
    respond_to do |format|
        format.js {}
      end
    else
      @stuffs = Stuff.all
      respond_to do |format|
        format.js { render 'reload_update' }
      end
    end
  end

  def show
    @total = Vote.where(:contest_id => @contest.id).count
    @results_by_stuff = @contest.results_by_stuff
    @results_by_hour = @contest.results_by_hour
  end

end
