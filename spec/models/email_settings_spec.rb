require 'rails_helper'

describe EmailSettings do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = {
      :user_id => @user.id,
    }
  end

  it "should create a new instance given a valid set of attributes" do
    email_settings = EmailSettings.new(@attr)
    expect(email_settings).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when user_id is empty' do
      @attr.delete(:user_id)
      email_settings = EmailSettings.new(@attr)
      expect(email_settings).not_to be_valid
    end
  end
end
