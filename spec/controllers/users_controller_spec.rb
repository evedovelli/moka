require 'rails_helper'

describe UsersController do

  before (:each) do
    @fake_user = FactoryGirl.create(:user)
  end

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if accessing home page" do
      get :home
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should have success when accessing user page" do
      allow(controller).to receive(:authorize!).and_return(true)
      get :show, {:id => @fake_user.username}
      expect(response).to have_http_status(:success)
    end
  end

  describe "When user is logged in" do
    before (:each) do
      sign_in @fake_user
    end

    describe "When user is not authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it "should be redirected to root page if accessing show page" do
        get :show, {:id => @fake_user.username}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing home page" do
        get :home
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "home" do
        before (:each) do
          @battles = [double("b1"), double("b2"), double("b3"), double("b4")]
          allow(Battle).to receive(:all).and_return(@battles)
          get :home
        end
        it "should respond to html" do
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the home template" do
          expect(response).to render_template('home')
        end
        it "should make all battles available to that template" do
          expect(assigns(:battles)).to eq(@battles)
        end
        it "should make the user available to that template" do
          expect(assigns(:user)).to eq(@fake_user)
        end
        it "should build a vote to the template" do
          expect(assigns(:vote)).to be_new_record
        end
      end

      describe "show" do
        before (:each) do
          @other_user = FactoryGirl.create(:user, {username: "other_user", email: "user@user.com"})
          @battles = [double("b1"), double("b2"), double("b3"), double("b4")]
          allow(@other_user).to receive(:sorted_battles).and_return(@battles)
          expect(User).to receive(:find_by_username!).with(@other_user.username).and_return(@other_user)
          get :show, {:id => @other_user.username}
        end
        it "should respond to html" do
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the show user template" do
          expect(response).to render_template('show')
        end
        it "should make all battles available to that template" do
          expect(assigns(:battles)).to eq(@battles)
        end
        it "should make the user available to that template" do
          expect(assigns(:user)).to eq(@other_user)
        end
        it "should build a vote to the template" do
          expect(assigns(:vote)).to be_new_record
        end
      end
    end

  end

end
