require 'rails_helper'

describe Users::OmniauthCallbacksController do
  before :each do
    # This a Devise specific thing for functional tests. See https://github.com/plataformatec/devise/issues/608
    request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
  end

  describe "connect with facebook" do
    describe "success" do
      it "should sign in and redirect to referer when authentication is ok" do
        @fake_user = FactoryGirl.create(:user)
        request.env["HTTP_REFERER"] = user_path(@fake_user.username)
        expect(@fake_user).to receive(:persisted?).and_return(true)
        expect(User).to receive(:find_for_oauth).and_return(@fake_user)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:notice]).to match("Successfully authenticated from Facebook account")
        expect(response).to redirect_to user_path(@fake_user.username)
      end
      it "should sign in and redirect to home page when referer is unknown" do
        @fake_user = FactoryGirl.create(:user)
        request.env["HTTP_REFERER"] = nil
        expect(@fake_user).to receive(:persisted?).and_return(true)
        expect(User).to receive(:find_for_oauth).and_return(@fake_user)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
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
        expect(flash[:alert]).to match("Could not authenticate you from facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when info is missing" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :uid => '123545',
          :provider => 'facebook'
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when uid is missing" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when provider is missing" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :uid => '123545',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from facebook because an unknown error occurred")
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
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from facebook because an unknown error occurred")
        expect(response).to redirect_to new_user_registration_url
      end
      it "should redirect to sign_up page with an error when credentials are missing" do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :uid => '123545',
          :provider => 'facebook',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:alert]).to match("Could not authenticate you from facebook because an unknown error occurred")
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
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
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
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
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
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
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
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
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
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        get :facebook
        expect(flash[:notice]).to match("A message with a confirmation link has been sent to your email address. Please open the link to activate your account.")
        expect(response).to redirect_to "where_i_came_from"
      end
    end

    describe "share battle" do
      it "should share battle on facebook and redirect to battle page" do
        @fake_user = FactoryGirl.create(:user)
        @fake_battle = FactoryGirl.create(:battle, user: @fake_user)
        request.env["HTTP_REFERER"] = user_path(@fake_user.username)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        request.env["omniauth.params"] = {
          "source" => "share",
          "battle_id" => @fake_battle.id
        }
        allow(controller).to receive(:authorize!).and_return(true)
        @resp = double("resp")
        @access_token = double("access_token")
        allow(@access_token).to receive(:[]).and_return("token")
        expect(Net::HTTP).to receive(:get).and_return(@resp)
        expect(Rack::Utils).to receive(:parse_nested_query).and_return(@access_token)
        expect(Net::HTTP).to receive(:post_form).with(
            URI('https://graph.facebook.com'),
            'id' => battle_url(@fake_battle.id),
            'scrape' => 'true',
            'access_token' => 'token',
            'max' => '500').and_return(true)
        @graph = double("graph")
        expect(@graph).to receive(:put_connections).with("me", "batalharia:create", battle: battle_url(@fake_battle.id))
        expect(Koala::Facebook::API).to receive(:new).with('ABCDEF').and_return(@graph)

        get :facebook
        expect(response).to redirect_to battle_path(@fake_battle.id)
      end
      it "should block non authorized shares" do
        @fake_user = FactoryGirl.create(:user)
        @fake_battle = FactoryGirl.create(:battle, user: @fake_user)
        request.env["HTTP_REFERER"] = user_path(@fake_user.username)

        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          :provider => 'facebook',
          :uid => '12345',
          :info => {
            :email => 'joe@bloggs.com',
            :name => 'Joe Bloggs',
            :verified => true
          },
          :credentials => {
            :token => 'ABCDEF',
            :expires_at => 1321747205,
            :expires => true
          }
        })
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
        request.env["omniauth.params"] = {
          "source" => "share",
          "battle_id" => @fake_battle.id
        }
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)

        get :facebook
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "share battle" do
    describe "success" do
      it 'should update scope and redirect to facebook auth path' do
        @fake_battle = FactoryGirl.create(:battle)
        get :share_battle, provider: "facebook", battle_id: @fake_battle.id
        expect(flash[:scope]).to match('public_profile,user_friends,email,publish_actions')
        expect(flash[:display]).to match('popup')
        expect(response).to redirect_to("/users/auth/facebook?source=share&battle_id=#{@fake_battle.id}")
      end
    end
    describe "error" do
      it 'should fail when provider is wrong' do
        @fake_battle = FactoryGirl.create(:battle)
        get :share_battle, provider: "twitter", battle_id: @fake_battle.id
        expect(flash[:scope]).to be_nil
        expect(flash[:display]).to be_nil
        expect(flash[:alert]).to match('Error while sharing battle on twitter')
        expect(response).to redirect_to(root_path)
      end
      it 'should fail when provider is missing' do
        @fake_battle = FactoryGirl.create(:battle)
        get :share_battle, provider: "twitter", battle_id: @fake_battle.id
        expect(flash[:scope]).to be_nil
        expect(flash[:display]).to be_nil
        expect(flash[:alert]).to match('Error while sharing battle on ')
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
