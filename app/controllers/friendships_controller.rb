class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :user, :find_by => :username
  load_and_authorize_resource :friendship, :through => :user, :except => [:create]


  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    authorize! :create, @friendship
    did_save = @friendship.save

    @friend = @friendship.friend
    current_user.send_friendship_notification_to(@friend) unless current_user == @friend

    if did_save
      FriendshipMailer.new_follower(current_user, @friend).deliver
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
