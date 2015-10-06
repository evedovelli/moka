require 'rails_helper'

describe FriendshipNotification do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = {
      :user => @user,
    }
  end

  describe 'validates presence of required attributes' do
    it 'should fails when type is empty' do
      notification = Notification.new(@attr)
      expect(notification).not_to be_valid
    end
  end

end
