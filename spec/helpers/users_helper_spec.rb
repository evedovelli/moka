require "rails_helper"

describe UsersHelper, :type => :helper do
  describe "user button for" do
    it "should return nothing if user not logged in" do
      allow(helper).to receive(:current_user).and_return(nil)
      expect(helper.user_button_for(@current_user)).to eq("<a href=\"/en/users/sign_in_popup\" class=\"btn btn-large btn-block btn-follow\" data-remote=\"true\"><i class=\"icon-plus\"></i> Follow</a>")
    end
    it "should return link to edit for current user" do
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@current_user)).to eq("<a href=\"/en/users/edit\" class=\"btn btn-info btn-block btn-large btn-edit-profile\">Edit account</a>")
    end
    it "should return link to unfollow when following the user" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      friendship = FactoryGirl.create(:friendship, user: @current_user, friend: @user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@user)).to eq("<a href=\"/en/users/tester/friendships/#{friendship.id}\" class=\"btn btn-success btn-unfollow btn-large btn-block\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\"><span class=\"following\"><i class=\"icon-ok icon-inverse\"></i> Following</span><span class=\"unfollow\"><i class=\"icon-remove icon-inverse\"></i> Unfollow</span></a>")
    end
    it "should return link to follow when not following the user" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@user)).to eq("<a href=\"/en/users/tester/friendships?friend_id=#{@user.id}\" class=\"btn btn-large btn-block btn-follow\" data-method=\"post\" data-remote=\"true\" rel=\"nofollow\"><i class=\"icon-plus\"></i> Follow</a>")
    end
    it "should return link to edit for current user with specific classes" do
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@current_user, "my_class")).to eq("<a href=\"/en/users/edit\" class=\"btn btn-info btn-block my_class btn-edit-profile\">Edit account</a>")
    end
    it "should return link to unfollow when following the user with specific classes" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      friendship = FactoryGirl.create(:friendship, user: @current_user, friend: @user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@user, "my_class")).to eq("<a href=\"/en/users/tester/friendships/#{friendship.id}\" class=\"btn btn-success btn-unfollow my_class btn-block\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\"><span class=\"following\"><i class=\"icon-ok icon-inverse\"></i> Following</span><span class=\"unfollow\"><i class=\"icon-remove icon-inverse\"></i> Unfollow</span></a>")
    end
    it "should return link to follow when not following the user with specific classes" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.user_button_for(@user, "my_class")).to eq("<a href=\"/en/users/tester/friendships?friend_id=#{@user.id}\" class=\"btn my_class btn-block btn-follow\" data-method=\"post\" data-remote=\"true\" rel=\"nofollow\"><i class=\"icon-plus\"></i> Follow</a>")
    end
  end

  describe "mini user button for" do
    it "should return nothing if user not logged in" do
      allow(helper).to receive(:current_user).and_return(nil)
      expect(helper.mini_user_button_for(@current_user)).to eq("<a href=\"/en/users/sign_in_popup\" class=\"btn btn-block btn-follow\" data-remote=\"true\"><i class=\"icon-plus\"></i><i class=\"icon-user\"></i></a>")
    end
    it "should return link to edit for current user" do
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.mini_user_button_for(@current_user)).to eq("<a href=\"/en/users/edit\" class=\"btn btn-info btn-block btn-edit-profile\"><i class=\"icon-edit\"></i></a>")
    end
    it "should return link to unfollow when following the user" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      friendship = FactoryGirl.create(:friendship, user: @current_user, friend: @user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.mini_user_button_for(@user)).to eq("<a href=\"/en/users/tester/friendships/#{friendship.id}\" class=\"btn btn-success btn-unfollow btn-block\" data-method=\"delete\" data-remote=\"true\" rel=\"nofollow\"><span class=\"following\"><i class=\"icon-ok icon-inverse\"></i><i class=\"icon-user icon-inverse\"></i></span><span class=\"unfollow\"><i class=\"icon-remove icon-inverse\"></i><i class=\"icon-user icon-inverse\"></i></span></a>")
    end
    it "should return link to follow when not following the user" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.mini_user_button_for(@user)).to eq("<a href=\"/en/users/tester/friendships?friend_id=#{@user.id}\" class=\"btn btn-block btn-follow\" data-method=\"post\" data-remote=\"true\" rel=\"nofollow\"><i class=\"icon-plus\"></i><i class=\"icon-user\"></i></a>")
    end
  end

  describe "user name for" do
    it "should return name when user has name" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user", name: "Kong")
      expect(helper.user_name_for(@user)).to eq("Kong")
    end
    it "should return username when user has no name" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      expect(helper.user_name_for(@user)).to eq("user")
    end
  end

  describe "from omniauth?" do
    it "should return false when user is nil" do
      @user = nil
      expect(helper.from_omniauth?(@user)).to eq(nil)
    end
    it "should return false when user identities is nil" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      expect(@user).to receive(:identities).and_return(nil)
      expect(helper.from_omniauth?(@user)).to eq(nil)
    end
    it "should return false when user identities is empty" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      expect(@user).to receive(:identities).twice.and_return([])
      expect(helper.from_omniauth?(@user)).to eq(false)
    end
    it "should return true when user identities has identities" do
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      expect(@user).to receive(:identities).twice.and_return([double])
      expect(helper.from_omniauth?(@user)).to eq(true)
    end
  end

  describe "find facebook frinds button" do
    it "should return link to find friends from facebook when signed in" do
      @current_user = FactoryGirl.create(:user)
      allow(helper).to receive(:user_signed_in?).and_return(true)
      allow(helper).to receive(:current_user).and_return(@current_user)
      expect(helper.find_facebook_friends_button("Run for your life")).to eq("<a href=\"/users/auth/facebook/friends\" class=\"btn btn-primary btn-large btn-facebook btn-block\" id=\"facebook-friends-find\"><table class=\"facebook-login-table\"><tr><td><i class=\"fa fa-facebook-square fa-2x\"></i></td><td></td><td>Run for your life</td></tr></table></a>")
    end
    it "should return empty string when not signed in" do
      allow(helper).to receive(:user_signed_in?).and_return(false)
      allow(helper).to receive(:current_user).and_return(nil)
      expect(helper.find_facebook_friends_button("Run for your life")).to eq("")
    end
  end
end
