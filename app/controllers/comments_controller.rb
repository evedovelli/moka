class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  load_and_authorize_resource :option
  load_and_authorize_resource :comment, :through => :option, :except => [:index]

  def create
    if @comment.save
      @user = current_user
      @option.battle.user.receive_comment_notification_from(@user, @option) unless @user == @option.battle.user

      users = []
      @option.comments.each do |comment|
        users.push(comment.user)
      end
      users.delete(@option.battle.user)
      users.uniq.each do |user|
        user.receive_comment_answer_notification_from(@user, @option) unless @user == user
      end

      @new_comment = Comment.new()
      respond_to do |format|
        format.js {}
      end
    else
      respond_to do |format|
        format.js { render 'comments/reload_form' }
      end
    end
  end

  def index
    @user = current_user
    if not @user
      respond_to do |format|
        format.js { render 'comments/unsigned_user' }
      end
      return
    end

    authorize! :index, Comment
    @comment = Comment.new()

    @comments = @option.ordered_comments(params[:page])
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    @comment_id = @comment.id
    @comment.destroy
    respond_to do |format|
      format.js {}
    end
  end

end
