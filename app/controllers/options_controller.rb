class OptionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :option

  def index
    @options = Option.all
  end

  def new
    respond_to do |format|
      format.js {}
    end
  end

  def create
    if @option.save
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
    @option_id = @option.id
    @option.destroy
    respond_to do |format|
      format.js {}
    end
  end

end
