require 'rails_helper'

describe ContestsController do

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
      post :create, { :contest => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if editing the page" do
      get :edit, {id: "0"}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if updating the page" do
      put :update, { :id => "0", :contest => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if destroying template" do
      delete :destroy, { :id => "0" }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should not be redirected to 'sign in' page if accessing show page" do
      @fake_contest = FactoryGirl.create(:contest)
      get :show, {id: @fake_contest.id}
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
        @fake_contest = FactoryGirl.create(:contest)
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
        post :create, { :stuff => {} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if editing the page" do
        get :edit, {id: @fake_contest.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if updating the page" do
        put :update, { :id => @fake_contest.id, :contest => {} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if creating template" do
        allow(Contest).to receive(:find).and_return(@fake_contest)
        delete :destroy, { :id => 1 }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if showing the page" do
        get :show, {id: @fake_contest.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        @fake_stuffs = [double('Stuff1'), double('Stuff2'), double('Stuff3')]
        allow(Stuff).to receive(:all).and_return(@fake_stuffs)
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "index" do
        before (:each) do
          @fake_contests = [double('Contest1'), double('Contest2'), double('Contest3')]
          allow(Contest).to receive(:all).and_return(@fake_contests)
          get :index
        end
        it "should respond to HTML" do
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the contest index" do
          expect(response).to render_template('contests')
        end
        it "should make the list of contests available to that template" do
          expect(assigns(:contests)).to eq(@fake_contests)
        end
      end

      describe "new" do
        it "should call new with correct art" do
          expect(Contest).to receive(:new)
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
        it "should make a new contest available to that template" do
          get :new, :format => 'js'
          expect(assigns(:contest)).to be_new_record
        end
        it "should make stuffs available to that template" do
          get :new, :format => 'js'
          expect(assigns(:stuffs)).to eq(@fake_stuffs)
        end
      end

      describe "create" do
        before :each do
          @fake_contest = FactoryGirl.create(:contest)
          allow(Contest).to receive(:new).and_return(@fake_contest)
        end
        it "should call new with correct art" do
          expect(Contest).to receive(:new).with({"starts_at" => "now"})
          post(:create, {contest: {"starts_at" => "now"}, :format => 'js'})
        end
        describe "in success" do
          before :each do
            allow(@fake_contest).to receive(:save).and_return(true)
            post(:create, {contest: {}, :format => 'js'})
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the create template" do
            expect(response).to render_template('create')
          end
          it "should make contest available to that template" do
            expect(assigns(:contest)).to eq(@fake_contest)
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_contest).to receive(:save).and_return(false)
            post(:create, {contest: {}, :format => 'js'})
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_form for template" do
            expect(response).to render_template('reload_form')
          end
          it "should make stuffs available to that template" do
            expect(assigns(:stuffs)).to eq(@fake_stuffs)
          end
        end
      end

      describe "edit" do
        before (:each) do
          @fake_contest = FactoryGirl.create(:contest)
          allow(Contest).to receive(:find).and_return(@fake_contest)
        end
        it "should call edit with correct id" do
          expect(Contest).to receive(:find).with("#{@fake_contest.id}")
          get :edit, {id: @fake_contest.id, :format => 'js'}
        end
        it "should respond to js" do
          get :edit, {id: @fake_contest.id, :format => 'js'}
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should render the edit template" do
          get :edit, {id: @fake_contest.id, :format => 'js'}
          expect(response).to render_template('edit')
        end
        it "should make the contest available to that template" do
          get :edit, {id: @fake_contest.id, :format => 'js'}
          expect(assigns(:contest)).to eq(@fake_contest)
        end
        it "should make stuffs available to that template" do
          get :edit, {id: @fake_contest.id, :format => 'js'}
          expect(assigns(:stuffs)).to eq(@fake_stuffs)
        end
      end

      describe "update" do
        before :each do
          @fake_contest = FactoryGirl.create(:contest)
          allow(Contest).to receive(:find).and_return(@fake_contest)
        end
        it "should call update with correct id" do
          expect(Contest).to receive(:find).with("#{@fake_contest.id}")
          put(:update, { :id => @fake_contest.id, contest: {"starts_at" => "now"}, :format => 'js' })
        end
        it "should update attributes of the contest" do
          expect(@fake_contest).to receive(:update_attributes).with({"starts_at" => "now", "stuff_ids" => []})
          put(:update, { :id => @fake_contest.id, contest: {"starts_at" => "now"}, :format => 'js' })
        end
        describe "in success" do
          before :each do
            allow(@fake_contest).to receive(:update_attributes).and_return(true)
            put(:update, { :id => @fake_contest.id, contest: {"starts_at" => "now"}, :format => 'js' })
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
            allow(@fake_contest).to receive(:update_attributes).and_return(false)
            put(:update, { :id => @fake_contest.id, contest: {"starts_at" => "now"}, :format => 'js' })
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_update template" do
            expect(response).to render_template('reload_update')
          end
          it "should make stuffs available to that template" do
            expect(assigns(:stuffs)).to eq(@fake_stuffs)
          end
        end
      end

      describe "destroy" do
        before :each do
          @fake_contest = FactoryGirl.create(:contest)
          allow(Contest).to receive(:find).and_return(@fake_contest)
        end
        it "should call destroy with correct id" do
          expect(Contest).to receive(:find).with("#{@fake_contest.id}")
          delete :destroy, { :id => @fake_contest.id, :format => 'js' }
        end
        it "should destroy the contest" do
          expect(@fake_contest).to receive(:destroy)
          delete :destroy, { :id => @fake_contest.id, :format => 'js' }
          expect(assigns(:contest_id)).to eq(@fake_contest.id)
        end
        it "should redirect to the destroy js" do
          delete :destroy, { :id => @fake_contest.id, :format => 'js' }
          expect(response).to render_template('destroy')
        end
      end

      describe "show" do
        before (:each) do
          @fake_contest = FactoryGirl.create(:contest)
          allow(Contest).to receive(:find).and_return(@fake_contest)
        end
        it "should call show with correct id" do
          expect(Contest).to receive(:find).with("#{@fake_contest.id}")
          get :show, {id: @fake_contest.id}
        end
        it "should respond to HTML" do
          get :show, {id: @fake_contest.id}
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the show template" do
          get :show, {id: @fake_contest.id}
          expect(response).to render_template('show')
        end
        it "should make the contest available to that template" do
          get :show, {id: @fake_contest.id}
          expect(assigns(:contest)).to eq(@fake_contest)
        end
        it "should make the total of votes available to that template" do
          allow(Vote).to receive(:where).and_return(Array.new(10, double("Vote")))
          get :show, {id: @fake_contest.id}
          expect(assigns(:total)).to eq(10)
        end
        it "should make the results by stuff available to that template" do
          results = double("results")
          allow(@fake_contest).to receive(:results_by_stuff).and_return(results)
          get :show, {id: @fake_contest.id}
          expect(assigns(:results_by_stuff)).to eq(results)
        end
        it "should make the results by hour available to that template" do
          results = double("results")
          allow(@fake_contest).to receive(:results_by_hour).and_return(results)
          get :show, {id: @fake_contest.id}
          expect(assigns(:results_by_hour)).to eq(results)
        end
      end

    end
  end

end
