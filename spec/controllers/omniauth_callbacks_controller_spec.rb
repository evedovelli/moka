require 'rails_helper'

describe Users::OmniauthCallbacksController do
  before :each do
    # This a Devise specific thing for functional tests. See https://github.com/plataformatec/devise/issues/608
    request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
  end

  describe "connect with facebook" do
    describe "success" do
      it "should sign in and redirect to home page when authentication is ok" do
        request.env["HTTP_REFERER"] = root_path
        @fake_user = FactoryGirl.create(:user)
        expect(@fake_user).to receive(:persisted?).and_return(true)
        expect(User).to receive(:find_for_oauth).and_return(@fake_user)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:notice]).to match("Successfully authenticated from Facebook account")
        expect(response).to redirect_to root_path
      end
    end

    describe "invalid auth data" do
      it "should redirect to sign_up page with an error when omniauth.auth is missing" do
        allow(@controller).to receive(:env).and_return({"some_other_key" => "some_other_value"})
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from Facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when info is missing" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :uid => '123545',
          :provider => 'facebook'
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from Facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when uid is missing" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from Facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when provider is missing" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :uid => '123545',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from Facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when provider is wrong" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :uid => '123545',
          :provider => 'twitter',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from Facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
    end

    describe "missing email" do
      it "should rerequest email if not present" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(response).to redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
      end
      it "should rerequest email if blank" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => '',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(response).to redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
      end
    end

    describe "user not persisted" do
      it "should redirect to signup page if user is not persisted" do
        @fake_user = FactoryGirl.create(:user)
        expect(@fake_user).to receive(:persisted?).and_return(false)
        expect(User).to receive(:find_for_oauth).and_return(@fake_user)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from Facebook because an error occurred")
        expect(response).to redirect_to new_user_registration_path
      end
      it "should redirect to signup page if facebook user is already connected to an account" do
        expect(User).to receive(:find_for_oauth).and_return(nil)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from Facebook because the account is already connected to an user")
        expect(response).to redirect_to root_path
      end
      it "should send email for confirmation if facebook user is not confirmed" do
        request.env["HTTP_REFERER"] = "where_i_came_from"
        @fake_user = FactoryGirl.create(:user)
        expect(@fake_user).to receive(:persisted?).and_return(true)
        expect(@fake_user).to receive(:confirmed?).and_return(false)
        expect(User).to receive(:find_for_oauth).and_return(@fake_user)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:notice]).to match("A message with a confirmation link has been sent to your email address. Please open the link to activate your account.")
        expect(response).to redirect_to "where_i_came_from"
      end
    end

  end
end
