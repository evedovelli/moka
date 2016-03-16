class VotesController < ApplicationController

  def create
    @user = current_user
    if not @user
      respond_to do |format|
        format.js { render 'votes/unsigned_user' }
      end
      return
    end

    if params[:vote] && params[:vote][:option_id]
      params[:vote][:user] = @user

      @vote = Vote.new(params[:vote])
      authorize! :create, @vote

      @selected_option_id = params[:vote][:option_id]

      existing_vote = current_user.vote_for(Option.find(@selected_option_id).battle)
      if existing_vote
        if (existing_vote.option_id == @selected_option_id)
          create_reload
          return
        else
          existing_notification = @user.sent_notifications.find_by_vote_id(existing_vote.id)
          if not existing_notification.blank?
            existing_notification.destroy
          end
          existing_vote.destroy
        end
      end

      if @vote.save
        @battle = @vote.battle
        @battle.user.receive_vote_notification_from(@user, @vote) unless @battle.user == @user
        @vote = Vote.new()
        respond_to do |format|
          format.js { render 'votes/create' }
        end
        return
      else
        flash[:alert] = @vote.error_message
        create_reload
        return
      end
    else
      create_reload
      return
    end
  end

  def create_reload
    @vote = Vote.new()
    respond_to do |format|
      format.js { render 'votes/reload_form' }
    end
  end

end
