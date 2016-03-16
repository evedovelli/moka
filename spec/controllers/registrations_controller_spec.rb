require 'rails_helper'

describe Users::RegistrationsController do
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "update resource" do
    describe "user registered only on app" do
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

    describe "user registered through Facebook" do
      before :each do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@leo.com',
            :name => 'Shell',
            :verified => true
            },
            :credentials => {
              :token => 'ABCDEF',
              :expires_at => 1321747205,
              :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        Capybara.current_session.driver.header 'Referer', root_url
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

  describe "create" do
    it "should create EmailSettings" do
      @email_settings = FactoryGirl.create(:email_settings)
      expect(EmailSettings).to receive(:create).and_return(@email_settings)
      post :create, { :user =>
                      { name: "Sinclair",
                        username: "dino",
                        email: "dino@sinclair.com",
                        password: "changeme",
                        password_confirmation: "changeme"
                      }
                    }
      expect(User.find_by_username("dino").email_settings).to eq @email_settings
    end
  end
end
