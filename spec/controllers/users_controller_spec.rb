require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

  describe "When users access its config page" do
    it "should see its own page" do
      get :home
      expect(assigns(:user)).to eq @user
    end
    it "should render the user home template" do
      get :home
      expect(response).to render_template 'home'
    end
  end

end
