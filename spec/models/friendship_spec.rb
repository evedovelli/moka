require 'rails_helper'

describe Friendship do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user, username: "friend", email: "friend@friend.com")
    @attr = {
      :user_id => @user.id,
      :friend_id => @friend.id
    }
  end

  it "should create a new instance given a valid set of attributes" do
    friendship = Friendship.new(@attr)
    expect(friendship).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when friend is empty' do
      @attr.delete(:friend_id)
      friendship = Friendship.new(@attr)
      expect(friendship).not_to be_valid
    end
    it 'should fails when user is empty' do
      @attr.delete(:user_id)
      friendship = Friendship.new(@attr)
      expect(friendship).not_to be_valid
    end
  end

  describe 'validates uniqueness of friend for an user' do
    it 'should fails when user is already following' do
      f = Friendship.new(@attr)
      f.save()
      friendship = Friendship.new(@attr)
      expect(friendship).not_to be_valid
    end
  end
end
