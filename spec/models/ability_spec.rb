require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  describe "user" do
    describe "admin user" do
      before :each do
        @user.add_role :admin
        @ability = Ability.new(@user)
      end

      describe "Resource User" do
        before :each do
          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
        end
        it "should be able to manage its User" do
          expect(@ability).to be_able_to(:manage, @user)
        end
        it "should be able to manage other User" do
          expect(@ability).to be_able_to(:manage, @other_user)
        end
      end

      describe "Resource EmailSettings" do
        it "should be able to manage email settings" do
          expect(@ability).to be_able_to(:manage, EmailSettings)
        end
      end

      describe "Resource Option" do
        it "should be able to manage options" do
          expect(@ability).to be_able_to(:manage, Option)
        end
      end

      describe "Resource Battle" do
        it "should be able to manage battles" do
          expect(@ability).to be_able_to(:manage, Battle)
        end
      end

      describe "Resource Vote" do
        before :each do
          @vote = FactoryGirl.create(:vote, user: @user)
        end
        it "should be able to read Votes" do
          expect(@ability).to be_able_to(:read, @vote)
        end
        it "should be able to create Votes" do
          expect(@ability).to be_able_to(:create, Vote)
        end
        it "should not be able to update Votes" do
          expect(@ability).not_to be_able_to(:update, @vote)
        end
        it "should not be able to destroy Votes" do
          expect(@ability).not_to be_able_to(:destroy, @vote)
        end
      end

      describe "Resource Friendship" do
        it "should be able to manage friendships" do
          expect(@ability).to be_able_to(:manage, Friendship)
        end
      end

      describe "Resource Notification" do
        it "should be able to manage notifications" do
          expect(@ability).to be_able_to(:manage, Notification)
        end
      end

      describe "Resource Comment" do
        it "should be able to manage comments" do
          expect(@ability).to be_able_to(:manage, Comment)
        end
      end
    end

    describe "other user" do
      before :each do
        @ability = Ability.new(@user)
      end

      describe "Resource User" do
        before :each do
          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
        end
        it "should be able to to access its home" do
          expect(@ability).to be_able_to(:home, @user)
        end
        it "should be able to read its User" do
          expect(@ability).to be_able_to(:read, @user)
        end
        it "should be able to access following for its User" do
          expect(@ability).to be_able_to(:following, @user)
        end
        it "should be able to access followers for its User" do
          expect(@ability).to be_able_to(:followers, @user)
        end
        it "should be able to create its User" do
          expect(@ability).to be_able_to(:create, User)
        end
        it "should be able to update its User" do
          expect(@ability).to be_able_to(:update, @user)
        end
        it "should be able to destroy its User" do
          expect(@ability).to be_able_to(:destroy, @user)
        end
        it "should be able to access social for its User" do
          expect(@ability).to be_able_to(:social, @user)
        end
        it "should be able to access facebook_friends for its User" do
          expect(@ability).to be_able_to(:facebook_friends, @user)
        end
        it "should be able to access locale" do
          expect(@ability).to be_able_to(:locale, User)
        end
        it "should be able to access find_friends" do
          expect(@ability).to be_able_to(:find_friends, User)
        end
        it "should be able to access sign_in_popup" do
          expect(@ability).to be_able_to(:sign_in_popup, User)
        end

        it "should not be able to to access home from other User" do
          expect(@ability).not_to be_able_to(:home, @other_user)
        end
        it "should be able to read other User" do
          expect(@ability).to be_able_to(:read, @other_user)
        end
        it "should be able to access following for other User" do
          expect(@ability).to be_able_to(:following, @other_user)
        end
        it "should be able to access followers for other User" do
          expect(@ability).to be_able_to(:followers, @other_user)
        end
        it "should not be able to update other User" do
          expect(@ability).not_to be_able_to(:update, @other_user)
        end
        it "should not be able to destroy other User" do
          expect(@ability).not_to be_able_to(:destroy, @other_user)
        end
        it "should not be able to access social for other User" do
          expect(@ability).not_to be_able_to(:social, @other_user)
        end
        it "should not be able to access facebook_friends for other User" do
          expect(@ability).not_to be_able_to(:facebook_friends, @other_user)
        end
      end

      describe "Resource EmailSettings" do
        before :each do
          @u1 = FactoryGirl.create(:user, email: "u1@u1.com", username: "u1")
          @my_email_settings = FactoryGirl.create(:email_settings, user: @user)
          @other_email_settings = FactoryGirl.create(:email_settings, user: @u1)
        end
        it "should not be able to show EmailSettings" do
          expect(@ability).not_to be_able_to(:show, @my_email_settings)
        end
        it "should not be able to index EmailSettings" do
          expect(@ability).not_to be_able_to(:index, EmailSettings)
        end
        it "should not be able to create EmailSettings" do
          expect(@ability).not_to be_able_to(:create, EmailSettings)
        end
        it "should be able to update EmailSettings" do
          expect(@ability).to be_able_to(:update, @my_email_settings)
        end
        it "should not be able to update others' EmailSettings" do
          expect(@ability).not_to be_able_to(:update, @other_email_settings)
        end
        it "should not be able to destroy his Friendships" do
          expect(@ability).not_to be_able_to(:destroy, @my_email_settings)
        end
      end

      describe "Resource Option" do
        before :each do
          t = Time.local(2015, 10, 21, 07, 28, 0)
          Timecop.travel(t)
          @option = FactoryGirl.create(:option)
          @battle = FactoryGirl.create(:battle,
                                       :starts_at => DateTime.now - 1.day,
                                       :duration => 48*60,
                                       :user => @user,
                                       :options => [@option])

          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
          @other_option = FactoryGirl.create(:option)
          @other_battle = FactoryGirl.create(:battle,
                                       :starts_at => DateTime.now - 1.day,
                                       :duration => 48*60,
                                       :user => @other_user,
                                       :options => [@other_option])
        end
        it "should be able to read options" do
          expect(@ability).to be_able_to(:read, Option)
        end
        it "should not be able to create options" do
          expect(@ability).not_to be_able_to(:create, Option)
        end
        it "should not be able to destroy options" do
          expect(@ability).not_to be_able_to(:destroy, @option)
        end
        it "should not be able to update options" do
          expect(@ability).not_to be_able_to(:update, @option)
        end

        it "should be able to show votes for past options" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:votes, @option)
        end
        it "should be able to show votes for past options for other users" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:votes, @other_option)
        end
        it "should be able to show votes for its options" do
          expect(@ability).to be_able_to(:votes, @option)
        end
        it "should be able to show votes for options in battles he has voted on" do
          FactoryGirl.create(:vote, user: @user, option: @other_battle.options[0] )
          expect(@ability).to be_able_to(:votes, @other_option)
        end
        it "should not be able to show votes for unfinished battles from other users" do
          expect(@ability).not_to be_able_to(:votes, @other_option)
        end
      end

      describe "Resource Battle" do
        before :each do
          t = Time.local(2015, 10, 21, 07, 28, 0)
          Timecop.travel(t)
          @battle = FactoryGirl.create(:battle,
                                       :starts_at => DateTime.now - 1.day,
                                       :duration => 48*60,
                                       :user => @user)
          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
          @other_battle = FactoryGirl.create(:battle,
                                       :starts_at => DateTime.now - 1.day,
                                       :duration => 48*60,
                                       :user => @other_user)
        end

        it "should be able to create battles" do
          expect(@ability).to be_able_to(:create, Battle)
        end

        it "should be able to update battles" do
          expect(@ability).to be_able_to(:update, @battle)
        end
        it "should not be able to update battles for other users" do
          expect(@ability).not_to be_able_to(:update, @other_battle)
        end
        it "should not be able to update finished battles" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).not_to be_able_to(:update, @battle)
        end

        it "should be able to destroy battles" do
          expect(@ability).to be_able_to(:destroy, @battle)
        end
        it "should not be able to destroy battles for other users" do
          expect(@ability).not_to be_able_to(:destroy, @other_battle)
        end

        it "should be able to show current battles" do
          expect(@ability).to be_able_to(:show, @battle)
        end
        it "should be able to show past battles" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:show, @battle)
        end
        it "should be able to show future battles from himself" do
          t = Time.local(2015, 10, 18, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:show, @battle)
        end
        it "should not be able to show future battles from other users" do
          t = Time.local(2015, 10, 18, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).not_to be_able_to(:show, @other_battle)
        end
        it "should not be able to show hidden battles" do
          @battle.hide
          expect(@ability).not_to be_able_to(:show, @battle)
        end

        it "should be able to show results for past battles" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:show_results, @battle)
        end
        it "should be able to show results for past battles for other users" do
          t = Time.local(2015, 10, 26, 07, 28, 0)
          Timecop.travel(t)
          expect(@ability).to be_able_to(:show_results, @other_battle)
        end
        it "should be able to show results for its battles" do
          expect(@ability).to be_able_to(:show_results, @battle)
        end
        it "should be able to show results for battles he has voted on" do
          FactoryGirl.create(:vote, user: @user, option: @other_battle.options[0] )
          expect(@ability).to be_able_to(:show_results, @other_battle)
        end
        it "should not be able to show results for unfinished battles from other users" do
          expect(@ability).not_to be_able_to(:show_results, @other_battle)
        end

        it "should not be able to index battles" do
          expect(@ability).not_to be_able_to(:index, Battle)
        end

        it "should be able to hashtag battles" do
          expect(@ability).to be_able_to(:hashtag, Battle)
        end

        it "should be able to share battles" do
          expect(@ability).not_to be_able_to(:share, @battle)
        end
        it "should not be able to share battles for other users" do
          expect(@ability).not_to be_able_to(:share, @other_battle)
        end
      end

      describe "Resource Vote" do
        before :each do
          @vote = FactoryGirl.create(:vote, user: @user)
        end
        it "should not be able to read Votes" do
          expect(@ability).not_to be_able_to(:read, @vote)
        end
        it "should be able to create Votes" do
          expect(@ability).to be_able_to(:create, Vote)
        end
        it "should not be able to update Votes" do
          expect(@ability).not_to be_able_to(:update, @vote)
        end
        it "should not be able to destroy Votes" do
          expect(@ability).not_to be_able_to(:destroy, @vote)
        end
      end

      describe "Resource Friendship" do
        before :each do
          @u1 = FactoryGirl.create(:user, email: "u1@u1.com", username: "u1")
          @u2 = FactoryGirl.create(:user, email: "u2@u2.com", username: "u2")
          @f1 = FactoryGirl.create(:friendship, user: @user, friend: @u1)
          @f2 = FactoryGirl.create(:friendship, user: @u2, friend: @user)
        end
        it "should not be able to show Friendships" do
          expect(@ability).not_to be_able_to(:show, @f1)
        end
        it "should not be able to index Friendships" do
          expect(@ability).not_to be_able_to(:index, Friendship)
        end
        it "should be able to create Friendships" do
          expect(@ability).to be_able_to(:create, Friendship)
        end
        it "should not be able to update Friendships" do
          expect(@ability).not_to be_able_to(:update, @f1)
        end
        it "should be able to destroy his Friendships" do
          expect(@ability).to be_able_to(:destroy, @f1)
        end
        it "should not be able to destroy others' Friendships" do
          expect(@ability).not_to be_able_to(:destroy, @f2)
        end
      end

      describe "Resource Notification" do
        before :each do
          @notification = FactoryGirl.create(:notification, user: @user)
          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
          @other_notification = FactoryGirl.create(:notification, user: @other_user)
        end
        it "should be able to show his Notifications" do
          expect(@ability).to be_able_to(:show, @notification)
        end
        it "should not be able to show others Notifications" do
          expect(@ability).not_to be_able_to(:show, @other_notification)
        end
        it "should be able to index Notifications" do
          expect(@ability).to be_able_to(:index, Notification)
        end
        it "should be able to create Notifications" do
          expect(@ability).to be_able_to(:create, Notification)
        end
        it "should not be able to update Notifications" do
          expect(@ability).not_to be_able_to(:update, @notification)
        end
        it "should not be able to destroy Notifications" do
          expect(@ability).not_to be_able_to(:destroy, @notification)
        end
        it "should be able to dropdown Notifications" do
          expect(@ability).to be_able_to(:dropdown, @notification)
        end
      end

      describe "Resource Comment" do
        before :each do
          @option = FactoryGirl.create(:option)
          @comment = FactoryGirl.create(:comment, user: @user, option: @option)
          @other_user = FactoryGirl.create(:user, email: "another@ex.com", username: "second")
          @other_comment = FactoryGirl.create(:comment, user: @other_user, option: @option)
          @battle = FactoryGirl.create(:battle, user: @user)
          @another_comment = FactoryGirl.create(:comment, user: @other_user, option: @battle.options[0])
        end
        it "should be able to create his Comments" do
          expect(@ability).to be_able_to(:create, @comment)
        end
        it "should not be able to create others Comments" do
          expect(@ability).not_to be_able_to(:create, @other_comment)
        end
        it "should be able to show his Comments" do
          expect(@ability).to be_able_to(:show, @comment)
        end
        it "should be able to show others Comments" do
          expect(@ability).to be_able_to(:show, @other_comment)
        end
        it "should be able to index Comments" do
          expect(@ability).to be_able_to(:index, Comment)
        end
        it "should not be able to update Comments" do
          expect(@ability).not_to be_able_to(:update, @comment)
        end
        it "should be able to destroy his Comments" do
          expect(@ability).to be_able_to(:destroy, @comment)
        end
        it "should not be able to destroy others Comments" do
          expect(@ability).not_to be_able_to(:destroy, @other_comment)
        end
        it "should be able to destroy others Comments in his battle" do
          expect(@ability).to be_able_to(:destroy, @another_comment)
        end
      end
    end

  end

end
