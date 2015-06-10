class VotesController < ApplicationController
  load_and_authorize_resource :vote

  def new
    @battle = Battle.current.first
    if not @battle
      render 'votes/no_battle'
      return
    end
    authorize! :show, @battle
    authorize! :create, Vote
    @vote = Vote.new()
  end

  def create
    @vote.valid? # Populates the error array for form even if there is error with recaptcha

    if verify_recaptcha(:model => @vote) && @vote.save
      @registered_vote = @vote
      @battle = @vote.battle
      @number_of_options = @battle.options.count
      @results_by_option = @battle.results_by_option
      @remaining_time = @battle.remaining_time
      @vote = Vote.new()
      respond_to do |format|
        format.js { render 'votes/create' }
      end
    else
      @battle = Battle.current.first
      flash[:alert] = @vote.error_message
      respond_to do |format|
        format.js { render 'votes/reload_form' }
      end
    end
  end

end
