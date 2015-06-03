require 'rails_helper'

describe OptionsController do

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if accessing index" do
      get :index
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if accessing new page" do
      get :new
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if creating template" do
      post :create, { :option => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if destroying template" do
      @fake_option = FactoryGirl.create(:option)
      allow(Option).to receive(:find).and_return(@fake_option)
      delete :destroy, { :id => 1 }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
  end

  describe "When user is logged in" do
    before (:each) do
      @fake_options = [double('Option1'), double('Option2'), double('Option3')]
      @fake_user = FactoryGirl.create(:user)
      sign_in @fake_user
    end

    describe "When user is not authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it "should be redirected to root page if accessing index" do
        get :index
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing new page" do
        get :new
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if creating template" do
        post :create, { :option => {} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if destroying template" do
        @fake_option = FactoryGirl.create(:option)
        allow(Option).to receive(:find).and_return(@fake_option)
        delete :destroy, { :id => 1 }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        allow(Option).to receive(:all).and_return(@fake_options)
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "index" do
        before (:each) do
          get :index
        end
        it "should respond to HTML" do
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the option index" do
          expect(response).to render_template('options')
        end
        it "should make the list of options available to that template" do
          expect(assigns(:options)).to eq(@fake_options)
        end
      end

      describe "new" do
        before (:each) do
          get :new, :format => 'js'
        end
        it "should respond to js" do
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the new template" do
          expect(response).to render_template('new')
        end
        it "should make a new option available to that template" do
          expect(assigns(:option)).to be_new_record
        end
      end

      describe "create" do
        before :each do
          @fake_option = FactoryGirl.create(:option)
          allow(Option).to receive(:new).and_return(@fake_option)
        end
        describe "in success" do
          before :each do
            allow(@fake_option).to receive(:save).and_return(true)
            post(:create, {option: {}, :format => 'js'})
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the create template" do
            expect(response).to render_template('create')
          end
          it "should make option available to that template" do
            expect(assigns(:option)).to eq(@fake_option)
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_option).to receive(:save).and_return(false)
          end
          it "should respond to js" do
            post(:create, {option: {}, :format => 'js'})
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_form for template" do
            post(:create, {page_template: {}, :format => 'js'})
            expect(response).to render_template('reload_form')
          end
        end
      end

      describe "destroy" do
        before :each do
          @fake_option = FactoryGirl.create(:option)
          allow(Option).to receive(:find).and_return(@fake_option)
        end
        it "should call destroy with correct id" do
          expect(Option).to receive(:find).with("#{@fake_option.id}")
          delete :destroy, { :id => @fake_option.id, :format => 'js' }
        end
        it "should destroy the option" do
          expect(@fake_option).to receive(:destroy)
          delete :destroy, { :id => @fake_option.id, :format => 'js' }
          expect(assigns(:option_id)).to eq(@fake_option.id)
        end
        it "should redirect to the destroy js" do
          delete :destroy, { :id => @fake_option.id, :format => 'js' }
          expect(response).to render_template('destroy')
        end
      end
    end
  end

end
