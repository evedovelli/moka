require 'rails_helper'

describe Comment do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @option = FactoryGirl.create(:option)
    @attr = {
      :user_id => @user.id,
      :body => "Unexpressive comment"
    }
  end

  it "should create a new instance given a valid set of attributes" do
    comment = @option.comments.new(@attr)
    expect(comment).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when user_id is empty' do
      @attr.delete(:user_id)
      comment = @option.comments.new(@attr)
      expect(comment).not_to be_valid
    end
    it 'should fails when body is empty' do
      @attr.delete(:body)
      comment = @option.comments.new(@attr)
      expect(comment).not_to be_valid
    end
  end
end
