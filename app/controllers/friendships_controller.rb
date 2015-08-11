class FriendshipsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :user, :find_by => :username
  load_and_authorize_resource :friendship, :through => :user, :except => [:create]


  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    authorize! :create, @friendship
    @friendship.save
    @friend = @friendship.friend
    respond_to do |format|
      format.js { render 'friendships/update_user_button' }
    end
  end

  def destroy
    @friend = @friendship.friend
    @friendship.destroy
    respond_to do |format|
      format.js { render 'friendships/update_user_button' }
    end
  end
end
