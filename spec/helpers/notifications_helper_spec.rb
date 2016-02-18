require "rails_helper"

describe NotificationsHelper, :type => :helper do
  describe "notifications btn" do
    it "should return div for no notifications with no user" do
      @fake_user = nil
      expect(helper.notifications_btn(@fake_user)).to eq('<div id="notifications-none"></div>')
    end
    it "should return div for no notifications with no new notifications" do
      @fake_user = FactoryGirl.create(:user)
      allow(@fake_user).to receive(:unread_notifications).and_return(0)
      expect(helper.notifications_btn(@fake_user)).to eq('<div id="notifications-none"></div>')
    end
    it "should return div for existing notifications with new notifications" do
      @fake_user = FactoryGirl.create(:user)
      allow(@fake_user).to receive(:unread_notifications).and_return(1)
      expect(helper.notifications_btn(@fake_user)).to eq("<div id=\"notifications-unread\"><p class=\"notifications-btn-text center\">1</p></div>")
    end
  end
end

