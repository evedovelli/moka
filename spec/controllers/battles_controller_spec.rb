require 'rails_helper'

describe BattlesController do

  describe "When user is not logged in" do
    describe "show" do
      before (:each) do
        @fake_battle = FactoryGirl.create(:battle)
        allow(controller).to receive(:authorize!).and_return(true)
        allow(Battle).to receive(:find).and_return(@fake_battle)
        get :show, { :id => @fake_battle.id }
      end
      it "should respond to html" do
        expect(response.content_type).to eq(Mime::HTML)
      end
      it "should render the cover template" do
        expect(response).to render_template('show')
      end
      it "should make battle available to that template" do
        expect(assigns(:battle)).to eq(@fake_battle)
      end
      it "should build a vote to the template" do
        expect(assigns(:vote)).to be_new_record
      end
    end

    it "should be redirected to 'sign in' page if accessing new battle page" do
      get :new
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if creating battle" do
      post :create, { :battle => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if editing the battle" do
      get :edit, {id: "0"}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if updating the battle" do
      put :update, { :id => "0", :battle => {} }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if destroying battle" do
      delete :destroy, { :id => "0" }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
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

      it "should be redirected to root page if showing the battle" do
        get :show, {id: @fake_battle.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing new battle page" do
        get :new
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if creating battle" do
        post :create, { :battle => {} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if editing the battle" do
        get :edit, {id: @fake_battle.id}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if updating the battle" do
        put :update, { :id => @fake_battle.id, :battle => {} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if destroying the battle" do
        allow(Battle).to receive(:find).and_return(@fake_battle)
        delete :destroy, { :id => 1 }
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

      describe "show" do
        before (:each) do
          @fake_battle = FactoryGirl.create(:battle)
          allow(Battle).to receive(:find).and_return(@fake_battle)
          get :show, { :id => @fake_battle.id }
        end
        it "should respond to html" do
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the cover template" do
          expect(response).to render_template('show')
        end
        it "should make battle available to that template" do
          expect(assigns(:battle)).to eq(@fake_battle)
        end
        it "should build a vote to the template" do
          expect(assigns(:vote)).to be_new_record
        end
      end

      describe "new" do
        it "should call new" do
          @fake_battle = FactoryGirl.create(:battle)
          expect(Battle).to receive(:new).and_return(@fake_battle)
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
        it "should build 2 options to the template" do
          get :new, :format => 'js'
          expect(assigns(:battle).options.length).to be_equal(2)
        end
        it "should make empty battle options error available to that template" do
          get :new, :format => 'js'
          expect(assigns(:battle_options_error)).to match("")
        end
        it "should make options_id available to that template" do
          get :new, :format => 'js'
          expect(assigns(:options_id)).to match("options_new")
        end
      end

      describe "create" do
        before :each do
          @fake_battle = FactoryGirl.create(:battle, {user: @fake_user})
          allow(Battle).to receive(:new).and_return(@fake_battle)
        end

        describe "battle is not specified" do
          it "should respond to js" do
            post(:create, {:format => 'js'})
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_form for battle" do
            post(:create, {:format => 'js'})
            expect(response).to render_template('reload_form')
          end
          it "should make options_id available to that template" do
            post(:create, {:format => 'js'})
            expect(assigns(:options_id)).to match("options_new")
          end
          it "should make battle_options_error available to that template" do
            post(:create, {:format => 'js'})
            expect(assigns(:battle_options_error)).to match("")
          end
        end

        describe "battle is specified" do
          it "should call new with correct starts_at and user" do
            Timecop.freeze(Time.local(1994))
            expect(Battle).to receive(:new).with({"duration" => (24*60).to_s,
                                                  "starts_at" => DateTime.now,
                                                  "user" => @fake_user,
                                                  "title" => "Who should win this battle?"})
            post(:create, {battle: {}, :format => 'js'})
          end
          it "should call new with correct duration" do
            Timecop.freeze(Time.local(1994))
            expect(Battle).to receive(:new).with({"duration" => "23",
                                                  "starts_at" => DateTime.now,
                                                  "user" => @fake_user,
                                                  "title" => "Who should win this battle?"})
            post(:create, {battle: {duration: "23"}, :format => 'js'})
          end
          it "should call new with correct title" do
            Timecop.freeze(Time.local(1994))
            expect(Battle).to receive(:new).with({"title" => "What?", "duration" => (24*60).to_s, "starts_at" => DateTime.now, "user" => @fake_user})
            post(:create, {battle: {title: "What?"}, :format => 'js'})
          end
          it "should call new with default duration and title when they are empty" do
            Timecop.freeze(Time.local(1994))
            expect(Battle).to receive(:new).with({"duration" => (24*60).to_s,
                                                  "starts_at" => DateTime.now,
                                                  "user" => @fake_user,
                                                  "title" => "Who should win this battle?"})
            post(:create, {battle: {duration: "", title: ""}, :format => 'js'})
          end
          it "should call new with default duration and title when not specified" do
            Timecop.freeze(Time.local(1994))
            expect(Battle).to receive(:new).with({"duration" => (24*60).to_s,
                                                  "starts_at" => DateTime.now,
                                                  "user" => @fake_user,
                                                  "title" => "Who should win this battle?"})
            post(:create, {battle: {}, :format => 'js'})
          end
          describe "in success" do
            before :each do
              @fake_vote = double("vote")
              allow(Vote).to receive(:new).and_return(@fake_vote)
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
            it "should make a new vote available to that template" do
              expect(assigns(:vote)).to eq(@fake_vote)
            end
            it "should make empty battle options error available to that template" do
              expect(assigns(:battle_options_error)).to match("")
            end
          end
          describe "in error" do
            before :each do
              allow(@fake_battle).to receive(:save).and_return(false)
            end
            it "should respond to js" do
              post(:create, {battle: {}, :format => 'js'})
              expect(response.content_type).to eq(Mime::JS)
            end
            it "should render the reload_form for battle" do
              post(:create, {battle: {}, :format => 'js'})
              expect(response).to render_template('reload_form')
            end
            it "should not have error for options when options are ok" do
              @errors = double("Errors")
              @messages = {'error1' => 'error'}
              allow(@fake_battle).to receive(:errors).and_return(@errors)
              allow(@errors).to receive(:any?).and_return(true)
              allow(@errors).to receive(:messages).and_return(@messages)
              post(:create, {battle: {}, :format => 'js'})
              expect(assigns(:battle_options_error)).to match("")
            end
            it "should have error for options when options are not ok" do
              @errors = double("Errors")
              @messages = {name: 'error', options: 'error in options'}
              allow(@fake_battle).to receive(:errors).and_return(@errors)
              allow(@errors).to receive(:any?).and_return(true)
              allow(@errors).to receive(:messages).and_return(@messages)
              post(:create, {battle: {}, :format => 'js'})
              expect(assigns(:battle_options_error)).to match("battle-options-error")
            end
            it "should make options_id available to that template" do
              post(:create, {battle: {}, :format => 'js'})
              expect(assigns(:options_id)).to match("options_new")
            end
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
        it "should respond to html" do
          get :edit, {id: @fake_battle.id}
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the edit template" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(response).to render_template('edit')
        end
        it "should make the battle available to that template" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(assigns(:battle)).to eq(@fake_battle)
        end
        it "should make empty battle options error available to that template" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(assigns(:battle_options_error)).to match("")
        end
        it "should make options_id available to that template" do
          get :edit, {id: @fake_battle.id, :format => 'js'}
          expect(assigns(:options_id)).to match("options#{@fake_battle.id}")
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
          expect(@fake_battle).to receive(:update_attributes).with({"starts_at" => "now"})
          put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
        end
        it "should update with correct duration" do
          expect(@fake_battle).to receive(:update_attributes).with({"duration" => "23"})
          put(:update, { :id => @fake_battle.id, battle: {"duration" => "23"}, :format => 'js' })
        end
        it "should update with correct title" do
          expect(@fake_battle).to receive(:update_attributes).with({"title" => "Ask?"})
          put(:update, { :id => @fake_battle.id, battle: {"title" => "Ask?"}, :format => 'js' })
        end
        it "should update with default duration and title when they are empty" do
          expect(@fake_battle).to receive(:update_attributes).with({"duration" => (24*60).to_s, "title" => @fake_battle.title})
          put(:update, { :id => @fake_battle.id, battle: {"duration" => "", "title" => ""}, :format => 'js' })
        end
        describe "in success" do
          before :each do
            allow(Vote).to receive(:new).and_return(@fake_vote)
            allow(@fake_battle).to receive(:save).and_return(true)
            allow(@fake_battle).to receive(:update_attributes).and_return(true)
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
          end
          it "should respond to js" do
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the update template" do
            expect(response).to render_template('update')
          end
          it "should make empty battle options error available to that template" do
            expect(assigns(:battle_options_error)).to match("")
          end
          it "should make a new vote available to that template" do
            expect(assigns(:vote)).to eq(@fake_vote)
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_battle).to receive(:update_attributes).and_return(false)
          end
          it "should respond to js" do
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the reload_update template" do
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
            expect(response).to render_template('reload_update')
          end
          it "should not have error for options when options are ok" do
            @errors = double("Errors")
            @messages = {'error1' => 'error'}
            allow(@fake_battle).to receive(:errors).and_return(@errors)
            allow(@errors).to receive(:any?).and_return(true)
            allow(@errors).to receive(:messages).and_return(@messages)
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
            expect(assigns(:battle_options_error)).to match("")
          end
          it "should have error for options when options are not ok" do
            @errors = double("Errors")
            @messages = {name: 'error', options: 'error in options'}
            allow(@fake_battle).to receive(:errors).and_return(@errors)
            allow(@errors).to receive(:any?).and_return(true)
            allow(@errors).to receive(:messages).and_return(@messages)
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
            expect(assigns(:battle_options_error)).to match("battle-options-error")
          end
          it "should make options_id available to that template" do
            put(:update, { :id => @fake_battle.id, battle: {"starts_at" => "now"}, :format => 'js' })
            expect(assigns(:options_id)).to match("options#{@fake_battle.id}")
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
          expect(@fake_battle).to receive(:hide)
          delete :destroy, { :id => @fake_battle.id, :format => 'js' }
          expect(assigns(:battle_id)).to eq(@fake_battle.id)
        end
        it "should redirect to the destroy js" do
          delete :destroy, { :id => @fake_battle.id, :format => 'js' }
          expect(response).to render_template('destroy')
        end
      end

    end
  end

end
