require 'rails_helper'

describe FriendshipsController do

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if creating friendship" do
      post :create, { :user_id => "user", :friend_id => "1" }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if destroying friendship" do
      delete :destroy, { :user_id => "user", :id => "0" }
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
  end

  describe "When user is logged in" do
    before (:each) do
      @fake_user = FactoryGirl.create(:user)
      @fake_friend = FactoryGirl.create(:user, username: "friend", email: "friend@friend.com")
      @friendship = FactoryGirl.create(:friendship, user: @fake_user, friend: @fake_friend)
      sign_in @fake_user
    end

    describe "When user is not authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it "should be redirected to root page if creating friendship" do
        post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if destroying the friendship" do
        delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "create" do
        before :each do
          @friendships = double("friendships")
          allow(@friendship).to receive(:friend).and_return(@fake_friend)
          allow(@friendships).to receive(:build).and_return(@friendship)
          allow(@fake_user).to receive(:friendships).and_return(@friendships)
          allow(controller).to receive(:current_user).and_return(@fake_user)

          @mail = double("mail")
          allow(@mail).to receive(:deliver)
          allow(FriendshipMailer).to receive(:new_follower).and_return(@mail)
        end
        it "should call build with correct friend_id" do
          expect(@friendships).to receive(:build).with({:friend_id => @fake_friend.id})
          post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
        end
        it "should call save for correct friendship" do
          expect(@friendship).to receive(:save)
          post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
        end
        it "should send notification for befriended user" do
          expect(@fake_user).to receive(:send_friendship_notification_to).with(@fake_friend)
          post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
        end
        it "should not send notification if befriended himself" do
          allow(@friendship).to receive(:friend).and_return(@fake_user)
          expect(@fake_user).not_to receive(:send_friendship_notification_to)
          post :create, { :user_id => @fake_user.username, :friend_id => @fake_user.id, :format => 'js' }
        end
        describe "in success" do
          before :each do
            allow(@friendship).to receive(:save).and_return(true)
          end
          it "should respond to js" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the update user button template" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(response).to render_template('friendships/update_user_button')
          end
          it "should make friendship available to that template" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(assigns(:friendship)).to eq(@friendship)
          end
          it "should make the friend available to that template" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(assigns(:friend)).to match(@fake_friend)
          end
          it "should send an email" do
            expect(@mail).to receive(:deliver)
            expect(FriendshipMailer).to receive(:new_follower).and_return(@mail)
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
          end
        end
        describe "in error" do
          before :each do
            allow(@friendship).to receive(:save).and_return(false)
          end
          it "should respond to js" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(response.content_type).to eq(Mime::JS)
          end
          it "should render the update user button template" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(response).to render_template('friendships/update_user_button')
          end
          it "should make friendship available to that template" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(assigns(:friendship)).to eq(@friendship)
          end
          it "should make the friend available to that template" do
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
            expect(assigns(:friend)).to match(@fake_friend)
          end
          it "should not send an email" do
            expect(@mail).not_to receive(:deliver)
            expect(FriendshipMailer).not_to receive(:new_follower)
            post :create, { :user_id => @fake_user.username, :friend_id => @fake_friend.id, :format => 'js' }
          end
        end
      end

      describe "destroy" do
        before :each do
          @friendships = double("friendships")
          allow(@friendships).to receive(:find).and_return(@friendship)
          allow(@fake_user).to receive(:friendships).and_return(@friendships)
          allow(User).to receive(:find_by_username!).and_return(@fake_user)
        end
        it "should search user with correct user id" do
          expect(User).to receive(:find_by_username!).with("#{@fake_user.username}")
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
        end
        it "should call destroy with correct id" do
          expect(@friendships).to receive(:find).with("#{@friendship.id}")
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
        end
        it "should call destroy for correct friendship" do
          expect(@friendship).to receive(:destroy)
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
        end
        it "should delete previous exiting notification if it exists" do
          notification = double("notification")
          expect(notification).to receive(:destroy)
          expect(FriendshipNotification).to receive(:where).and_return([notification])
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
        end
        it "should not delete previous exiting notification if it does not exists" do
          notification = double("notification")
          expect(notification).not_to receive(:destroy)
          expect(FriendshipNotification).to receive(:where).and_return([])
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
        end
        it "should respond to js" do
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
          expect(response.content_type).to eq(Mime::JS)
        end
        it "should redirect to the update user button template" do
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
          expect(response).to render_template('friendships/update_user_button')
        end
        it "should make the friend available to that template" do
          delete :destroy, { :user_id => @fake_user.username, :id => @friendship.id, :format => 'js' }
          expect(assigns(:friend)).to match(@fake_friend)
        end
      end

    end

  end
end
