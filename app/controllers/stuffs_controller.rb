class StuffsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :stuff

  def index
    @stuffs = Stuff.all
  end

  def new
    respond_to do |format|
      format.js {}
    end
  end

  def create
    if @stuff.save
      respond_to do |format|
        format.js {}
      end
    else
      respond_to do |format|
        format.js { render 'reload_form' }
      end
    end
  end

  def destroy
    @stuff_id = @stuff.id
    @stuff.destroy
    respond_to do |format|
      format.js {}
    end
  end

end
