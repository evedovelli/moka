require 'rails_helper'

describe OptionsController do

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if accessing votes for option" do
      get :votes, {id: 1}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
  end

  describe "When user is logged in" do
    before (:each) do
      @fake_user = FactoryGirl.create(:user)
      sign_in @fake_user
      @fake_option = FactoryGirl.create(:option)
    end

    describe "When user is not authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it "should be redirected to root page if accessing new battle page" do
        get :votes, {id: @fake_option.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "votes" do
        before (:each) do
          allow(Option).to receive(:find).and_return(@fake_option)
        end
        it "should call find with correct arguments" do
          expect(Option).to receive(:find).with("#{@fake_option.id}").and_return(@fake_option)
          get :votes, {id: @fake_option.id, :format => 'js'}
        end
        it "should respond to js" do
          get :votes, {id: @fake_option.id, :format => 'js'}
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the votes template" do
          get :votes, {id: @fake_option.id, :format => 'js'}
          expect(response).to render_template('votes')
        end
        it "should make the option available to that template" do
          get :votes, {id: @fake_option.id, :format => 'js'}
          expect(assigns(:option)).to eq(@fake_option)
        end
      end

    end
  end

end
