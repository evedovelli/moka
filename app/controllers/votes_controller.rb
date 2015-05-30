class VotesController < ApplicationController
  load_and_authorize_resource :contest, :except => :new
  load_and_authorize_resource :vote, :through => :contest, :except => :new

  def new
    @contest = Contest.current.first
    if not @contest
      render 'votes/no_contest'
      return
    end
    authorize! :show, @contest
    authorize! :create, Vote
    @vote = @contest.votes.new()
  end

  def create
    @vote.valid? # Populates the error array for form even if there is error with recaptcha

    if verify_recaptcha(:model => @vote) && @vote.save
      @registered_vote = @vote
      @vote = @contest.votes.new()
      @number_of_stuffs = @contest.stuffs.count
      @results_by_stuff = @contest.results_by_stuff
      @remaining_time = @contest.remaining_time
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
