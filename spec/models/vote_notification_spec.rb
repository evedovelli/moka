require 'rails_helper'

describe VoteNotification do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @sender = FactoryGirl.create(:user, username: "sender", email: "sender@sender.com")
    @vote = FactoryGirl.create(:vote, user: @sender)
    @attr = {
      :user => @user,
      :vote => @vote,
      :sender => @sender
    }
  end

  it "should create a new instance given a valid set of attributes" do
    notification = VoteNotification.new(@attr)
    expect(notification).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when user is empty' do
      @attr.delete(:user)
      notification = VoteNotification.new(@attr)
      expect(notification).not_to be_valid
    end
    it 'should fails when vote is empty' do
      @attr.delete(:vote)
      notification = VoteNotification.new(@attr)
      expect(notification).not_to be_valid
    end
    it 'should fails when sender is empty' do
      @attr.delete(:sender)
      notification = VoteNotification.new(@attr)
      expect(notification).not_to be_valid
    end
  end

end
