require 'rails_helper'

describe EmailSettingsController do

  describe "When user is not logged in" do
    it "should be redirected to 'sign in' page if editing the email settings" do
      get :edit, {user_id: "0"}
      expect(flash[:alert]).to match("You need to sign in or sign up before continuing.")
      expect(response).to redirect_to("/en/users/sign_in")
    end
    it "should be redirected to 'sign in' page if updating the email settings" do
      put :update, {:user_id => "0"}
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

      it "should be redirected to root page if editing the email settings" do
        get :edit, {user_id: @fake_user.username}
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
      it "should be redirected to root page if updating the battle" do
        put :update, {user_id: @fake_user.username, :email_settings => {} }
        expect(flash[:alert]).to match("Access denied.")
        expect(response).to redirect_to(root_url)
      end
    end

    describe "When user is authorized" do
      before (:each) do
        allow(controller).to receive(:authorize!).and_return(true)
      end

      describe "edit" do
        before (:each) do
          @fake_email_settings = FactoryGirl.create(:email_settings, user: @fake_user)
          allow(@fake_user).to receive(:email_settings).and_return(@fake_email_settings)
          allow(User).to receive(:find_by_username!).and_return(@fake_user)
        end
        it "should call edit with correct id" do
          expect(@fake_user).to receive(:email_settings)
          expect(User).to receive(:find_by_username!).and_return(@fake_user)
          get :edit, {user_id: @fake_user.username}
        end
        it "should respond to html" do
          get :edit, {user_id: @fake_user.username}
          expect(response.content_type).to eq(Mime::HTML)
        end
        it "should render the edit template" do
          get :edit, {user_id: @fake_user.username}
          expect(response).to render_template('edit')
        end
        it "should make the email settings available to that template" do
          get :edit, {user_id: @fake_user.username}
          expect(assigns(:email_settings)).to eq(@fake_email_settings)
        end
        it "should make user available to that template" do
          get :edit, {user_id: @fake_user.username}
          expect(assigns(:user)).to match(@fake_user)
        end
      end

      describe "update" do
        before :each do
          @fake_email_settings = FactoryGirl.create(:email_settings, user: @fake_user)
          allow(@fake_user).to receive(:email_settings).and_return(@fake_email_settings)
          allow(User).to receive(:find_by_username!).and_return(@fake_user)
        end
        it "should call update with correct id" do
          expect(@fake_user).to receive(:email_settings)
          expect(User).to receive(:find_by_username!).and_return(@fake_user)
          put(:update, {user_id: @fake_user.username, :email_settings => {new_follower: false}})
        end
        it "should update attributes of the email settings" do
          expect(@fake_email_settings).to receive(:update_attributes).with({new_follower: false})
          put(:update, {user_id: @fake_user.username, :email_settings => {new_follower: false}})
        end
        describe "in success" do
          before :each do
            allow(@fake_email_settings).to receive(:update_attributes).and_return(true)
            put(:update, {user_id: @fake_user.username, :email_settings => {new_follower: false}})
          end
          it "should respond to HTML" do
            expect(response.content_type).to eq(Mime::HTML)
          end
          it "should redirect to user profile" do
            expect(response).to redirect_to user_path(@fake_user)
          end
          it "should set the flash notice" do
            expect(flash[:notice]).to match "Your email settings were successfully updated!"
          end
        end
        describe "in error" do
          before :each do
            allow(@fake_email_settings).to receive(:update_attributes).and_return(false)
            put(:update, {user_id: @fake_user.username, :email_settings => {new_follower: false}})
          end
          it "should respond to HTML" do
            expect(response.content_type).to eq(Mime::HTML)
          end
          it "should render the edit template" do
            expect(response).to render_template('edit')
          end
          it "should make the email settings available to that template" do
            expect(assigns(:email_settings)).to eq(@fake_email_settings)
          end
          it "should make user available to that template" do
            expect(assigns(:user)).to match(@fake_user)
          end
        end
      end

    end
  end

end
