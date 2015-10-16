require 'rails_helper'

describe UsersController do

  before (:each) do
    @fake_user = FactoryGirl.create(:user)
  end

  describe "When user is not logged in" do
    describe "home" do
      it "should respond to html" do
        get :home
        expect(response.content_type).to eq(Mime::HTML)
      end
      it "should render the cover template" do
        get :home
        expect(response).to render_template('cover', 'cover')
      end
    end
    it "should have success when accessing user page" do
      allow(controller).to receive(:authorize!).and_return(true)
      get :show, {:id => @fake_user.username}
      expect(response).to have_http_status(:success)
    end
    it "should make the voted for battles available when accessing user page" do
      get :show, {:id => @fake_user.username}
      expect(assigns(:voted_for)).to eq({})
    end
    it "should have success when accessing user index page" do
      allow(controller).to receive(:authorize!).and_return(true)
      get :index
      expect(response).to have_http_status(:success)
    end
    it "should have success when accessing following page" do
      allow(controller).to receive(:authorize!).and_return(true)
      get :following, {:id => @fake_user.username}
      expect(response).to have_http_status(:success)
    end
    it "should have success when accessing followers page" do
      allow(controller).to receive(:authorize!).and_return(true)
      get :followers, {:id => @fake_user.username}
      expect(response).to have_http_status(:success)
    end
    it "should be redirected to 'sign in' page if editing user" do
      get :edit, {:id => @fake_user.username}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if updating user" do
      put :update, { :id => @fake_user.username, :user => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
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

      it "should be redirected to root page if accessing home page" do
        get :home
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing show page" do
        get :show, {:id => @fake_user.username}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing index page" do
        get :index
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing following page" do
        get :following, {:id => @fake_user.username}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing followers page" do
        get :followers, {:id => @fake_user.username}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if editing user" do
        get :edit, {:id => @fake_user.username}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if updating user" do
        put :update, { :id => @fake_user.username, :user => {} }
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
          @voted_for = double("vf")
          allow(Battle).to receive(:user_home).and_return(@battles)
          allow(@fake_user).to receive(:voted_for_options).with(@battles).and_return(@voted_for)
          allow(controller).to receive(:current_user).and_return(@fake_user)
        end
        it "should respond to html" do
          get :home
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the home template" do
          get :home
          expect(response).to render_template('home')
        end
        it "should respond to js" do
          get :home, :format => 'js'
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the load_more_battles template with js" do
          get :home, :format => 'js'
          expect(response).to render_template('load_more_battles')
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
        it "should call voted_for_options with correct argument" do
          expect(@fake_user).to receive(:voted_for_options).with(@battles).and_return(@voted_for)
          get :home
        end
        it "should make the voted for battles available to that template" do
          get :home
          expect(assigns(:voted_for)).to eq(@voted_for)
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
          allow(User).to receive(:find_by_username!).with(@other_user.username).and_return(@other_user)
          @voted_for = double("vf")
          allow(@fake_user).to receive(:voted_for_options).and_return(@voted_for)
          allow(controller).to receive(:current_user).and_return(@fake_user)
        end
        it "should search user with correct user id" do
          expect(User).to receive(:find_by_username!).with("#{@other_user.username}")
          get :show, {:id => @other_user.username}
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
        it "should call voted_for_options with correct argument" do
          expect(@fake_user).to receive(:voted_for_options).with(@battles).and_return(@voted_for)
          get :show, {:id => @other_user.username}
        end
        it "should make the voted for battles available to that template" do
          get :show, {:id => @other_user.username}
          expect(assigns(:voted_for)).to eq(@voted_for)
        end
        it "should make the user available to that template" do
          get :show, {:id => @other_user.username}
          expect(assigns(:user)).to eq(@other_user)
        end
        it "should build a vote to the template" do
          get :show, {:id => @other_user.username}
          expect(assigns(:vote)).to be_new_record
        end
        it "should make the number of following available to that template" do
          allow(@other_user).to receive(:friends).and_return([double("1"), double("2"), double("3")])
          get :show, {:id => @other_user.username}
          expect(assigns(:number_of_following)).to eq(3)
        end
        it "should make the number of followers available to that template" do
          allow(@other_user).to receive(:inverse_friends).and_return([double("1"), double("2"), double("3")])
          get :show, {:id => @other_user.username}
          expect(assigns(:number_of_followers)).to eq(3)
        end
      end

      describe "index" do
        before (:each) do
          @users = [double("b1"), double("b2"), double("b3"), double("b4")]
          allow(controller).to receive(:current_user).and_return(@fake_user)
        end
        it "should not search user" do
          expect(User).not_to receive(:find_by_username!)
          get :index
        end
        it "should respond to html" do
          get :index
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the show user template with HTML" do
          get :index
          expect(response).to render_template('index')
        end
        it "should respond to js" do
          get(:index, {:format => 'js'})
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the show user template with JS" do
          get(:index, {:format => 'js'})
          expect(response).to render_template('index')
        end
        it "should search users with search word param" do
          expect(User).to receive(:search).with("calvin", "2")
          get(:index, {search: "calvin", page: "2"})
        end
        it "should search users with search word from session" do
          session[:user_search] = "hobbes"
          expect(User).to receive(:search).with("hobbes", "3")
          get(:index, {page: "3"})
        end
        it "should search users with search word param whenever it exists" do
          session[:user_search] = "hobbes"
          expect(User).to receive(:search).with("calvin", "1")
          get(:index, {search: "calvin", page: "1"})
        end
        it "should replace search word from session with search word param whenever it exists" do
          session[:user_search] = "hobbes"
          get(:index, {search: "calvin", page: "1"})
          expect(session[:user_search]).to match("calvin")
        end
        it "should not replace search word from session with no search word param" do
          session[:user_search] = "hobbes"
          get(:index, {page: "1"})
          expect(session[:user_search]).to match("hobbes")
        end
        it "should return found users" do
          allow(User).to receive(:search).and_return(@users)
          get(:index, {search: "calvin", page: "2"})
          expect(assigns(:users)).to eq(@users)
        end
      end

      describe "following" do
        before (:each) do
          @other_user = FactoryGirl.create(:user, {username: "other_user", email: "user@user.com"})
          @friends = [double("f1"), double("f2"), double("f3"), double("f4")]
          allow(@other_user).to receive(:friends).and_return(@friends)
          allow(User).to receive(:find_by_username!).with(@other_user.username).and_return(@other_user)
        end
        it "should search user with correct user id" do
          expect(User).to receive(:find_by_username!).with("#{@other_user.username}")
          get :following, {:id => @other_user.username}
        end
        it "should respond to html" do
          get :following, {:id => @other_user.username}
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the following template" do
          get :following, {:id => @other_user.username}
          expect(response).to render_template('following')
        end
        it "should make the list of following users available to that template" do
          get :following, {:id => @other_user.username}
          expect(assigns(:following)).to eq(@friends)
        end
        it "should make the user available to that template" do
          get :following, {:id => @other_user.username}
          expect(assigns(:user)).to eq(@other_user)
        end
      end

      describe "followers" do
        before (:each) do
          @other_user = FactoryGirl.create(:user, {username: "other_user", email: "user@user.com"})
          @inverse_friends = [double("f1"), double("f2"), double("f3"), double("f4")]
          allow(@other_user).to receive(:inverse_friends).and_return(@inverse_friends)
          allow(User).to receive(:find_by_username!).with(@other_user.username).and_return(@other_user)
        end
        it "should search user with correct user id" do
          expect(User).to receive(:find_by_username!).with("#{@other_user.username}")
          get :followers, {:id => @other_user.username}
        end
        it "should respond to html" do
          get :followers, {:id => @other_user.username}
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the followers template" do
          get :followers, {:id => @other_user.username}
          expect(response).to render_template('followers')
        end
        it "should make the list of followers users available to that template" do
          get :followers, {:id => @other_user.username}
          expect(assigns(:followers)).to eq(@inverse_friends)
        end
        it "should make the user available to that template" do
          get :followers, {:id => @other_user.username}
          expect(assigns(:user)).to eq(@other_user)
        end
      end

      describe "edit" do
        before (:each) do
          allow(User).to receive(:find_by_username!).with(@fake_user.username).and_return(@fake_user)
        end
        it "should search user with correct user id" do
          expect(User).to receive(:find_by_username!).with("#{@fake_user.username}")
          get :edit, {:id => @fake_user.username, :format => 'js'}
        end
        it "should respond to html" do
          get :edit, {:id => @fake_user.username, :format => 'js'}
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the following template" do
          get :edit, {:id => @fake_user.username, :format => 'js'}
          expect(response).to render_template('edit')
        end
        it "should make the user available to that template" do
          get :edit, {:id => @fake_user.username, :format => 'js'}
          expect(assigns(:user)).to eq(@fake_user)
        end
      end

      describe "update" do
        before :each do
          allow(User).to receive(:find_by_username!).and_return(@fake_user)
          @fake_avatar = "avatar"
        end
        it "should call update with correct id" do
          expect(User).to receive(:find_by_username!).with("#{@fake_user.username}")
          put(:update, { :id => @fake_user.username, user: {} })
        end
        it "should update attributes of the user" do
          expect(@fake_user).to receive(:update_attributes).with({:avatar => @fake_avatar})
          put(:update, { :id => @fake_user.username, user: {"avatar" => @fake_avatar} })
        end
        it "should fill flash alert if user is empty" do
          put(:update, { :id => @fake_user.username })
          expect(flash[:alert]).to match("Invalid image")
        end
        it "should fill flash alert if avatar is empty" do
          put(:update, { :id => @fake_user.username, user: {} })
          expect(flash[:alert]).to match("Invalid image")
        end
        describe "in success" do
          before :each do
            allow(@fake_user).to receive(:update_attributes).and_return(true)
            put(:update, { :id => @fake_user.username, user: {"avatar" => @fake_avatar} })
          end
          it "should respond to HTML" do
            expect(response.content_type).to eq(Mime::HTML)
          end
          it "should not fill flash alert" do
            expect(flash[:alert]).to be_nil
          end
          it "should redirect to the user profile page" do
            expect(response).to redirect_to(user_path(@fake_user))
          end
          it "should make the user available to that template" do
            expect(assigns(:user)).to eq(@fake_user)
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_user).to receive(:update_attributes).and_return(false)
            put(:update, { :id => @fake_user.username, user: {"avatar" => @fake_avatar} })
          end
          it "should respond to HTML" do
            expect(response.content_type).to eq(Mime::HTML)
          end
          it "should fill flash alert with error message" do
            expect(flash[:alert]).to match("Invalid image")
          end
          it "should redirect to the user profile page" do
            expect(response).to redirect_to(user_path(@fake_user))
          end
          it "should make the user available to that template" do
            expect(assigns(:user)).to eq(@fake_user)
          end
        end
      end

    end

  end

end
