require "spec_helper"

describe UsersHelper, :type => :helper do
  describe "user button for" do
    it "should return link to edit for current user" do
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@current_user)).to eq("<a href=\"/en/users/edit\" class=\"btn btn-info btn-block btn-large btn-edit-profile\">Edit profile</a>")
    end
    it "should return link to unfollow when following the user" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      FactoryGirl.create(:friendship, user: @current_user, friend: @user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@user)).to eq("<a href=\"/en/users/tester/friendships/1\" class=\"btn btn-success btn-unfollow btn-large btn-block\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\"><span class=\"following\"><i class=\"icon-ok icon-inverse\"></i> Following</span><span class=\"unfollow\"><i class=\"icon-remove icon-inverse\"></i> Unfollow</span></a>")
    end
    it "should return link to follow when not following the user" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@user)).to eq("<a href=\"/en/users/tester/friendships?friend_id=1\" class=\"btn btn-large btn-block btn-follow\" data-method=\"post\" data-remote=\"true\" rel=\"nofollow\"><i class=\"icon-plus\"></i> Follow</a>")
    end
  end
end
