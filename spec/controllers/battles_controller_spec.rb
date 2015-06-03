require 'rails_helper'

describe BattlesController do

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
      post :create, { :battle => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if editing the page" do
      get :edit, {id: "0"}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if updating the page" do
      put :update, { :id => "0", :battle => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if destroying template" do
      delete :destroy, { :id => "0" }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should not be redirected to 'sign in' page if accessing show page" do
      @fake_battle = FactoryGirl.create(:battle)
      get :show, {id: @fake_battle.id}
      expect(flash[:alert]).not_to match("You need to sign in or sign up before continuing.")
      expect(response).not_to redirect_to("/en/users/sign_in")
    end
  end

  describe "When user is logged in" do
    before (:each) do
      @fake_user = FactoryGirl.create(:user)
      sign_in @fake_user
    end

    describe "When user is not authorized" do
      before (:each) do
        @fake_battle = FactoryGirl.create(:battle)
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
      it "should be redirected to root page if editing the page" do
        get :edit, {id: @fake_battle.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if updating the page" do
        put :update, { :id => @fake_battle.id, :battle => {} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if creating template" do
        allow(Battle).to receive(:find).and_return(@fake_battle)
        delete :destroy, { :id => 1 }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if showing the page" do
        get :show, {id: @fake_battle.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        @fake_options = [double('Option1'), double('Option2'), double('Option3')]
        allow(Option).to receive(:all).and_return(@fake_options)
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "index" do
        before (:each) do
          @fake_battles = [double('Battle1'), double('Battle2'), double('Battle3')]
          allow(Battle).to receive(:all).and_return(@fake_battles)
          get :index
        end
        it "should respond to HTML" do
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the battle index" do
          expect(response).to render_template('battles')
        end
        it "should make the list of battles available to that template" do
          expect(assigns(:battles)).to eq(@fake_battles)
        end
      end

      describe "new" do
        it "should call new with correct art" do
          expect(Battle).to receive(:new)
          get :new, :format => 'js'
        end
        it "should respond to js" do
          get :new, :format => 'js'
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the new template" do
          get :new, :format => 'js'
          expect(response).to render_template('new')
        end
        it "should make a new battle available to that template" do
          get :new, :format => 'js'
          expect(assigns(:battle)).to be_new_record
        end
        it "should make options available to that template" do
          get :new, :format => 'js'
          expect(assigns(:options)).to eq(@fake_options)
        end
      end

      describe "create" do
        before :each do
          @fake_battle = FactoryGirl.create(:battle)
          allow(Battle).to receive(:new).and_return(@fake_battle)
        end
        it "should call new with correct art" do
          expect(Battle).to receive(:new).with({"starts_at" => "now"})
          post(:create, {battle: {"starts_at" => "now"}, :format => 'js'})
        end
        describe "in success" do
          before :each do
            allow(@fake_battle).to receive(:save).and_return(true)
            post(:create, {battle: {}, :format => 'js'})
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the create template" do
            expect(response).to render_template('create')
          end
          it "should make battle available to that template" do
            expect(assigns(:battle)).to eq(@fake_battle)
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_battle).to receive(:save).and_return(false)
            post(:create, {battle: {}, :format => 'js'})
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_form for template" do
            expect(response).to render_template('reload_form')
          end
          it "should make options available to that template" do
            expect(assigns(:options)).to eq(@fake_options)
          end
        end
      end

      describe "edit" do
        before (:each) do
          @fake_battle = FactoryGirl.create(:battle)
          allow(Battle).to receive(:find).and_return(@fake_battle)
        end
        it "should call edit with correct id" do
          expect(Battle).to receive(:find).with("#{@fake_battle.id}")
          get :edit, {id: @fake_battle.id, :format => 'js'}
        end
        it "should respond to js" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the edit template" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(response).to render_template('edit')
        end
        it "should make the battle available to that template" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(assigns(:battle)).to eq(@fake_battle)
        end
        it "should make options available to that template" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(assigns(:options)).to eq(@fake_options)
        end
      end

      describe "update" do
        before :each do
          @fake_battle = FactoryGirl.create(:battle)
          allow(Battle).to receive(:find).and_return(@fake_battle)
        end
        it "should call update with correct id" do
          expect(Battle).to receive(:find).with("#{@fake_battle.id}")
          put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
        end
        it "should update attributes of the battle" do
          expect(@fake_battle).to receive(:update_attributes).with({"starts_at" => "now", "option_ids" => []})
          put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
        end
        describe "in success" do
          before :each do
            allow(@fake_battle).to receive(:update_attributes).and_return(true)
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the update template" do
            expect(response).to render_template('update')
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_battle).to receive(:update_attributes).and_return(false)
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_update template" do
            expect(response).to render_template('reload_update')
          end
          it "should make options available to that template" do
            expect(assigns(:options)).to eq(@fake_options)
          end
        end
      end

      describe "destroy" do
        before :each do
          @fake_battle = FactoryGirl.create(:battle)
          allow(Battle).to receive(:find).and_return(@fake_battle)
        end
        it "should call destroy with correct id" do
          expect(Battle).to receive(:find).with("#{@fake_battle.id}")
          delete :destroy, { :id => @fake_battle.id, :format => 'js' }
        end
        it "should destroy the battle" do
          expect(@fake_battle).to receive(:destroy)
          delete :destroy, { :id => @fake_battle.id, :format => 'js' }
          expect(assigns(:battle_id)).to eq(@fake_battle.id)
        end
        it "should redirect to the destroy js" do
          delete :destroy, { :id => @fake_battle.id, :format => 'js' }
          expect(response).to render_template('destroy')
        end
      end

      describe "show" do
        before (:each) do
          @fake_battle = FactoryGirl.create(:battle)
          allow(Battle).to receive(:find).and_return(@fake_battle)
        end
        it "should call show with correct id" do
          expect(Battle).to receive(:find).with("#{@fake_battle.id}")
          get :show, {id: @fake_battle.id}
        end
        it "should respond to HTML" do
          get :show, {id: @fake_battle.id}
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the show template" do
          get :show, {id: @fake_battle.id}
          expect(response).to render_template('show')
        end
        it "should make the battle available to that template" do
          get :show, {id: @fake_battle.id}
          expect(assigns(:battle)).to eq(@fake_battle)
        end
        it "should make the total of votes available to that template" do
          allow(Vote).to receive(:where).and_return(Array.new(10, double("Vote")))
          get :show, {id: @fake_battle.id}
          expect(assigns(:total)).to eq(10)
        end
        it "should make the results by option available to that template" do
          results = double("results")
          allow(@fake_battle).to receive(:results_by_option).and_return(results)
          get :show, {id: @fake_battle.id}
          expect(assigns(:results_by_option)).to eq(results)
        end
        it "should make the results by hour available to that template" do
          results = double("results")
          allow(@fake_battle).to receive(:results_by_hour).and_return(results)
          get :show, {id: @fake_battle.id}
          expect(assigns(:results_by_hour)).to eq(results)
        end
      end

    end
  end

end
