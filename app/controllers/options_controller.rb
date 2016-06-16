class OptionsController < ApplicationController
  load_and_authorize_resource :option

  def votes
    if !current_user
      respond_to do |format|
        format.js { render 'votes/unsigned_user' }
      end
      return
    end

    @votes = @option.ordered_votes(params[:page])
    respond_to do |format|
      format.js {}
    end
  end

end
