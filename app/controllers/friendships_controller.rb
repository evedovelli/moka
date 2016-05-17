class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :user, :find_by => :username
  load_and_authorize_resource :friendship, :through => :user, :except => [:create]


  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    authorize! :create, @friendship

    if @friendship.save && (current_user != @friend)
      @friend = @friendship.friend
      @friend.receive_friendship_notification_from(current_user)
      @friend.receive_friendship_email_from(current_user)
    end

    respond_to do |format|
      format.js { render 'friendships/update_user_button' }
    end
  end

  def destroy
    @friend = @friendship.friend
    @friendship.destroy

    if existing_notification = FriendshipNotification.where("sender_id = ? AND user_id = ?", current_user.id, @friend.id).first
      existing_notification.destroy
    end

    respond_to do |format|
      format.js { render 'friendships/update_user_button' }
    end
  end
end
