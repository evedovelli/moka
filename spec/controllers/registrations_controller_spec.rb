require 'rails_helper'

describe Users::RegistrationsController do
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "updates user registered only on app" do
    before :each do
      @fake_user = FactoryGirl.create(:user, name: "Shell")
      sign_in @fake_user
    end

    it "should fail to update without the password" do
      put :update, { :id => @fake_user.username, :user => {name: "Sinclair"} }
      expect(response).to have_http_status(:success)
      expect(response).to render_template("devise/registrations/edit")
      @fake_user = User.find_by_username("tester")
      expect(@fake_user.name).to eq "Shell"
    end
    it "should succeed to update with the password" do
      put :update, { :id => @fake_user.username, :user => {name: "Sinclair", current_password: 'changeme'} }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to root_path
      @fake_user = User.find_by_username("tester")
      expect(@fake_user.name).to eq "Sinclair"
    end
  end

  describe "updates user registered through Facebook" do
    before :each do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook',
        :uid => '12345',
        :info => {
          :email => 'joe@leo.com',
          :name => 'Shell',
          :verified => true
        }
      })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
      visit '/users/auth/facebook'
      @fake_user = User.find_by_username("joe")
      sign_in @fake_user
    end

    it "should succeed to update without password" do
      put :update, { :id => "joe", :user => {name: "Sinclair"} }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to root_path
      @fake_user = User.find_by_username("joe")
      expect(@fake_user.name).to eq "Sinclair"
    end
  end
end
