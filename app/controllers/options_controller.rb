class OptionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :option

  def votes
    respond_to do |format|
      format.js {}
    end
  end

end
