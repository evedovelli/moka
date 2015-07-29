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
          allow(Battle).to receive(:user_home).and_return(@battles)
        end
        it "should respond to html" do
          get :home
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should respond to js" do
          get :home, :format => 'js'
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the home template" do
          get :home
          expect(response).to render_template('home')
        end
        it "should make user_home battles available to that template" do
          get :home
          expect(assigns(:battles)).to eq(@battles)
        end
        it "should receive user_home with user and page" do
          expect(Battle).to receive(:user_home).with(@fake_user, "2").and_return(@battles)
          get :home, {page: "2"}
          expect(assigns(:battles)).to eq(@battles)
        end
        it "should make the user available to that template" do
          get :home
          expect(assigns(:user)).to eq(@fake_user)
        end
        it "should build a vote to the template" do
          get :home
          expect(assigns(:vote)).to be_new_record
        end
      end

      describe "show" do
        before (:each) do
          @other_user = FactoryGirl.create(:user, {username: "other_user", email: "user@user.com"})
          @battles = [double("b1"), double("b2"), double("b3"), double("b4")]
          allow(@other_user).to receive(:sorted_battles).and_return(@battles)
          expect(User).to receive(:find_by_username!).with(@other_user.username).and_return(@other_user)
        end
        it "should respond to html" do
          get :show, {:id => @other_user.username}
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should respond to js" do
          get(:show, {:id => @other_user.username, :format => 'js'})
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the show user template" do
          get :show, {:id => @other_user.username}
          expect(response).to render_template('show')
        end
        it "should make all battles available to that template" do
          get :show, {:id => @other_user.username}
          expect(assigns(:battles)).to eq(@battles)
        end
        it "should call sorted_battles with the correct page" do
          expect(@other_user).to receive(:sorted_battles).with("3").and_return(@battles)
          get :show, {:id => @other_user.username, :page => "3"}
        end
        it "should make the user available to that template" do
          get :show, {:id => @other_user.username}
          expect(assigns(:user)).to eq(@other_user)
        end
        it "should build a vote to the template" do
          get :show, {:id => @other_user.username}
          expect(assigns(:vote)).to be_new_record
        end
      end
    end

  end

end
