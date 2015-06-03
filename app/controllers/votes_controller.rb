class VotesController < ApplicationController
  load_and_authorize_resource :battle, :except => :new
  load_and_authorize_resource :vote, :through => :battle, :except => :new

  def new
    @battle = Battle.current.first
    if not @battle
      render 'votes/no_battle'
      return
    end
    authorize! :show, @battle
    authorize! :create, Vote
    @vote = @battle.votes.new()
  end

  def create
    @vote.valid? # Populates the error array for form even if there is error with recaptcha

    if verify_recaptcha(:model => @vote) && @vote.save
      @registered_vote = @vote
      @vote = @battle.votes.new()
      @number_of_options = @battle.options.count
      @results_by_option = @battle.results_by_option
      @remaining_time = @battle.remaining_time
      respond_to do |format|
        format.js { render 'votes/create' }
      end
    else
      flash[:alert] = @vote.error_message
      respond_to do |format|
        format.js { render 'votes/reload_form' }
      end
    end
  end

end
