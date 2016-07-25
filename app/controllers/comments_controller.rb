class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  load_and_authorize_resource :option
  load_and_authorize_resource :comment, :through => :option, :except => [:index]

  def create
    if @comment.save
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
