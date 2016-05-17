require 'rails_helper'

describe FacebookFriendship do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user, username: "friend", email: "friend@friend.com")
    @attr = {
      :user => @user,
      :facebook_friend => @friend
    }
  end

  it "should create a new instance given a valid set of attributes" do
    friendship = FacebookFriendship.new(@attr)
    expect(friendship).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when facebook friend is empty' do
      @attr.delete(:facebook_friend)
      friendship = FacebookFriendship.new(@attr)
      expect(friendship).not_to be_valid
    end
    it 'should fails when user is empty' do
      @attr.delete(:user)
      friendship = FacebookFriendship.new(@attr)
      expect(friendship).not_to be_valid
    end
  end

  describe 'validates uniqueness of friend for an user' do
    it 'should fails when user is already friend' do
      f = FacebookFriendship.new(@attr)
      f.save()
      friendship = FacebookFriendship.new(@attr)
      expect(friendship).not_to be_valid
    end
  end
end
