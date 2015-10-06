require 'rails_helper'

describe NotificationsController do

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if accessing notification index" do
      get :index
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if accessing notification dropdown" do
      get :dropdown
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
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it "should be redirected to root page if accessing notification index" do
        get :index
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if accessing notification dropdown" do
        get :dropdown
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end


    describe "When user is authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "index" do
        before :each do
          @sender = FactoryGirl.create(:user, username: "sender", email: "sender@sender.com")
          @vote = FactoryGirl.create(:vote, user: @sender)
          @attr = {
            user: @fake_user,
            sender: @sender,
            vote: @vote
          }
          @notifications1 = []
          @notifications2 = []
          @notifications3 = []
          for i in 1..15
            @notifications1 << VoteNotification.create!(@attr)
            Timecop.travel(DateTime.now + i.minutes)
          end
          for i in 16..30
            @notifications2 << VoteNotification.create!(@attr)
            Timecop.travel(DateTime.now + i.minutes)
          end
          for i in 31..45
            @notifications3 << VoteNotification.create!(@attr)
            Timecop.travel(DateTime.now + i.minutes)
          end
          allow(controller).to receive(:current_user).and_return(@fake_user)
        end
        it "should call notifications from correct user" do
          expect(@fake_user).to receive(:notifications).and_return(@fake_user.notifications)
          get :index, { :page => 1 }
        end
        it "should call reset_unread_notifications from correct user" do
          expect(@fake_user).to receive(:reset_unread_notifications)
          get :index, { :page => 1 }
        end
        describe "HTML" do
          it "should respond to html" do
            get :index, { :page => 1 }
            expect(response.content_type).to eq(Mime::HTML)
          end
          it "should render the index HTML template" do
            get :index, { :page => 1 }
            expect(response).to render_template('index')
          end
          it "should make the notifications available to that template" do
            get :index
            expect(assigns(:notifications)).to eq(@notifications3.reverse)
          end
          it "should make the notifications from right page available to that template" do
            get :index, { :page => 2 }
            expect(assigns(:notifications)).to eq(@notifications2.reverse)
          end
          it "should not make the notifications available when page does not exist" do
            get :index, { :page => 4 }
            expect(assigns(:notifications)).to eq([])
          end
        end
        describe "JS" do
          it "should respond to js" do
            get :index, { :page => 1, format: 'js' }
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the index template" do
            get :index, { :page => 1, format: 'js' }
            expect(response).to render_template('index')
          end
          it "should make the notifications available to that template" do
            get :index, { format: 'js' }
            expect(assigns(:notifications)).to eq(@notifications3.reverse)
          end
          it "should make the notifications from right page available to that template" do
            get :index, { :page => 2, format: 'js' }
            expect(assigns(:notifications)).to eq(@notifications2.reverse)
          end
          it "should not make the notifications available when page does not exist" do
            get :index, { :page => 4, format: 'js' }
            expect(assigns(:notifications)).to eq([])
          end
        end
      end

      describe "dropdown" do
        before :each do
          @sender = FactoryGirl.create(:user, username: "sender", email: "sender@sender.com")
          @vote = FactoryGirl.create(:vote, user: @sender)
          @attr = {
            user: @fake_user,
            sender: @sender,
            vote: @vote
          }
          @notifications1 = []
          @notifications2 = []
          @notifications3 = []
          for i in 1..6
            @notifications1 << VoteNotification.create!(@attr)
            Timecop.travel(DateTime.now + i.minutes)
          end
          for i in 7..12
            @notifications2 << VoteNotification.create!(@attr)
            Timecop.travel(DateTime.now + i.minutes)
          end
          for i in 13..18
            @notifications3 << VoteNotification.create!(@attr)
            Timecop.travel(DateTime.now + i.minutes)
          end
          allow(controller).to receive(:current_user).and_return(@fake_user)
        end
        it "should call notifications from correct user" do
          expect(@fake_user).to receive(:notifications).and_return(@fake_user.notifications)
          get :dropdown, { :page => 1, format: 'js' }
        end
        it "should call reset_unread_notifications from correct user" do
          expect(@fake_user).to receive(:reset_unread_notifications)
          get :dropdown, { :page => 1, format: 'js' }
        end
        describe "JS" do
          it "should respond to js" do
            get :dropdown, { :page => 1, format: 'js' }
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the dropdown template" do
            get :dropdown, { :page => 1, format: 'js' }
            expect(response).to render_template('dropdown')
          end
          it "should make the notifications available to that template" do
            get :dropdown, { format: 'js' }
            expect(assigns(:notifications)).to eq(@notifications3.reverse)
          end
          it "should make the notifications from right page available to that template" do
            get :dropdown, { :page => 2, format: 'js' }
            expect(assigns(:notifications)).to eq(@notifications2.reverse)
          end
          it "should not make the notifications available when page does not exist" do
            get :dropdown, { :page => 4, format: 'js' }
            expect(assigns(:notifications)).to eq([])
          end
        end
      end

    end
  end

end
