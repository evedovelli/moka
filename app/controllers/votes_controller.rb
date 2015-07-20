class VotesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :vote

  def create
    @selected_option_id = params[:vote][:option_id]
    if @vote.save
      @battle = @vote.battle
      @vote = Vote.new()
      respond_to do |format|
        format.js { render 'votes/create' }
      end
    else
      flash[:alert] = @vote.error_message
      @vote = Vote.new()
      respond_to do |format|
        format.js { render 'votes/reload_form' }
      end
    end
  end

end
