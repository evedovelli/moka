require 'rails_helper'

describe CommentAnswerNotification do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @sender = FactoryGirl.create(:user, username: "sender", email: "sender@sender.com")
    @option = FactoryGirl.create(:option)
    @attr = {
      :user => @user,
      :option => @option,
      :sender => @sender
    }
  end

  it "should create a new instance given a valid set of attributes" do
    notification = CommentAnswerNotification.new(@attr)
    expect(notification).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when user is empty' do
      @attr.delete(:user)
      notification = CommentAnswerNotification.new(@attr)
      expect(notification).not_to be_valid
    end
    it 'should fails when option is empty' do
      @attr.delete(:option)
      notification = CommentAnswerNotification.new(@attr)
      expect(notification).not_to be_valid
    end
    it 'should fails when sender is empty' do
      @attr.delete(:sender)
      notification = CommentAnswerNotification.new(@attr)
      expect(notification).not_to be_valid
    end
  end

end
