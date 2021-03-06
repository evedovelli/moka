require 'rails_helper'

describe User do

  before(:each) do
    @attr = {
      :email => "user@example.com",
      :username => "testuser",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "should create a new instance given a valid attribute" do
    user = User.new(@attr)
    expect(user).to be_valid
  end

  it "should create a new instance with optional attributes included" do
    user = User.new(@attr.merge({
      :name => "Fred Flintstone",
      :avatar => File.new(Rails.root + 'spec/fixtures/images/tomato.png')
    }))
    expect(user).to be_valid
  end

  describe 'validates attached avatar' do
    it 'should validates attachment content type' do
      user = User.new(@attr.merge(:avatar => File.new(Rails.root + 'spec/fixtures/images/no_image.txt')))
      expect(user).not_to be_valid
    end
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    expect(no_email_user).not_to be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      expect(valid_email_user).to be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      expect(invalid_email_user).not_to be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    @new_attr = {
      :email => "user@example.com",
      :username => "usertest",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
    user_with_duplicate_email = User.new(@new_attr)
    expect(user_with_duplicate_email).not_to be_valid
  end

  it "should reject identical email addresses upcased" do
    User.create!(@attr)
    @new_attr = {
      :email => @attr[:email].upcase,
      :username => "usertest",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
    user_with_duplicate_email = User.new(@new_attr)
    expect(user_with_duplicate_email).not_to be_valid
  end

  it "should require an username" do
    no_username_user = User.new(@attr.merge(:username => ""))
    expect(no_username_user).not_to be_valid
  end

  it "should reject duplicate username" do
    User.create!(@attr)
    @new_attr = {
      :email => "example@user.com",
      :username => "testuser",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
    user_with_duplicate_username = User.new(@new_attr)
    expect(user_with_duplicate_username).not_to be_valid
  end

  it "should reject identical username upcased" do
    User.create!(@attr)
    @new_attr = {
      :email => "example@user.com",
      :username => @attr[:username].upcase,
      :password => "changeme",
      :password_confirmation => "changeme"
    }
    user_with_duplicate_username = User.new(@new_attr)
    expect(user_with_duplicate_username).not_to be_valid
  end

  describe "destroy" do
    before(:each) do
      @user = User.new(@attr)
      @user.save
    end
    it "should destroy user's battles" do
      battle = FactoryGirl.create(:battle, user: @user)
      expect(battle).not_to be_nil
      expect{ @user.destroy }.to change {Battle.count}.by(-1)
    end
    it "should destroy user's friendships" do
      friendship = FactoryGirl.create(:friendship, user: @user)
      expect(friendship).not_to be_nil
      expect{ @user.destroy }.to change{ Friendship.count }.by(-1)
    end
    it "should destroy user's inverse friendships" do
      friendship = FactoryGirl.create(:friendship, friend: @user)
      expect(friendship).not_to be_nil
      expect{ @user.destroy }.to change{ Friendship.count }.by(-1)
    end
    it "should destroy user's votes" do
      vote = FactoryGirl.create(:vote, user: @user)
      expect(vote).not_to be_nil
      expect{ @user.destroy }.to change{ Vote.count }.by(-1)
    end
    it "should destroy user's notifications" do
      friend = FactoryGirl.create(:user)
      @vote = FactoryGirl.create(:vote, user: friend)
      notification = VoteNotification.new({ :user => @user,
                                            :vote => @vote,
                                            :sender => friend
                                          })
      notification.save
      expect(notification).not_to be_nil
      expect{ @user.destroy }.to change{ VoteNotification.count }.by(-1)
    end
    it "should destroy user's sent notifications" do
      friend = FactoryGirl.create(:user)
      @vote = FactoryGirl.create(:vote, user: @user)
      notification = VoteNotification.new({ :user => friend,
                                            :vote => @vote,
                                            :sender => @user
                                          })
      notification.save
      expect(notification).not_to be_nil
      expect{ @user.destroy }.to change{ VoteNotification.count }.by(-1)
    end
    it "should destroy user's identities" do
      identity = FactoryGirl.create(:identity, user: @user)
      expect(identity).not_to be_nil
      expect{ @user.destroy }.to change{ Identity.count }.by(-1)
    end
    it "should destroy user's email_settings" do
      email_settings = FactoryGirl.create(:email_settings, user: @user)
      expect(email_settings).not_to be_nil
      expect{ @user.destroy }.to change{ EmailSettings.count }.by(-1)
    end
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      expect(@user).to respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      expect(@user).to respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      expect(User.new(@attr.merge(:password => "", :password_confirmation => ""))).
        not_to be_valid
    end

    it "should require a matching password confirmation" do
      expect(User.new(@attr.merge(:password_confirmation => "invalidpass"))).
        not_to be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      expect(User.new(hash)).not_to be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      expect(@user).to respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      expect(@user.encrypted_password).not_to be_blank
    end

  end

  describe 'authentication methods' do
    before (:each) do
    end
    it "should finds user by email" do
      @email = "foo@bar.com"
      @warden_conditions = { :login => @email }
      user = FactoryGirl.create(:user, email: @email)
      authenticated = User.find_for_database_authentication(@warden_conditions)
      expect(authenticated).to eql(user)
    end
    it "should finds user by username" do
      @username = "foo"
      @warden_conditions = { :login => @username }
      user = FactoryGirl.create(:user, username: @username)
      authenticated = User.find_for_database_authentication(@warden_conditions)
      expect(authenticated).to eql(user)
    end
    it "should finds without login" do
      @email = "foo@bar.com"
      user = FactoryGirl.create(:user, email: @email)
      @warden_conditions = { :email => @email }
      authenticated = User.find_for_database_authentication(@warden_conditions)
      expect(authenticated).to eql(user)
    end
  end

  describe 'has_valid_characters' do
    it 'should reject .' do
      user = User.new(@attr.merge(:username => "user.name"))
      expect(user).not_to be_valid
    end
    it 'should reject special characters' do
      user = User.new(@attr.merge(:username => "usernéime"))
      expect(user).not_to be_valid
    end
    it 'should reject spaces' do
      user = User.new(@attr.merge(:username => "user name"))
      expect(user).not_to be_valid
    end
    it 'should reject bars' do
      user = User.new(@attr.merge(:username => "user/name"))
      expect(user).not_to be_valid
    end
    it 'should accept letters and underlines' do
      user = User.new(@attr.merge(:username => "USER_name"))
      expect(user).to be_valid
    end
  end

  describe 'reserved_username' do
    it 'should reject sign_in' do
      user = User.new(@attr.merge(:username => "sign_in"))
      expect(user).not_to be_valid
    end
    it 'should reject sign_out' do
      user = User.new(@attr.merge(:username => "sign_out"))
      expect(user).not_to be_valid
    end
    it 'should reject sign_up' do
      user = User.new(@attr.merge(:username => "sign_up"))
      expect(user).not_to be_valid
    end
    it 'should reject facebook_friends' do
      user = User.new(@attr.merge(:username => "facebook_friends"))
      expect(user).not_to be_valid
    end
    it 'should reject sign_in_popup' do
      user = User.new(@attr.merge(:username => "sign_in_popup"))
      expect(user).not_to be_valid
    end
  end

  describe 'to_param' do
    it 'should return the username' do
      user = User.create!(@attr)
      expect(user.to_param).to eq("testuser")
    end
  end

  describe 'find_for_oauth' do
    before :each do
      @fake_user = FactoryGirl.create(:user)
      @auth = OmniAuth::AuthHash.new({
        :provider => 'fakebook',
        :uid => '92312312',
        :info => {
          :name => 'Pamela Anderson',
          :email => 'pamela@malibu.com',
          :verified => true
        }
      })
    end

    describe 'signed in resource' do
      it 'should save identity to current user if not saved' do
        @identity = FactoryGirl.create(:identity)
        expect(Identity).to receive(:find_for_oauth).with(@auth).and_return(@identity)

        @other_user = FactoryGirl.create(:user, username: "other", email: "other@email.com")
        expect(@identity).to receive(:save!).and_return(true)
        user = User.find_for_oauth(@auth, @other_user)
        expect(@identity.user).to eq user
        expect(user).to eq @other_user
      end
      it 'should not save identity to current user if saved' do
        @identity = FactoryGirl.create(:identity, user: @fake_user)
        expect(Identity).to receive(:find_for_oauth).with(@auth).and_return(@identity)

        expect(@identity).not_to receive(:save!)
        user = User.find_for_oauth(@auth, @fake_user)
        expect(@identity.user).to eq user
      end
      it 'should return nil if identity user exists and is different to current user' do
        @identity = FactoryGirl.create(:identity, user: @fake_user)
        expect(Identity).to receive(:find_for_oauth).with(@auth).and_return(@identity)

        @other_user = FactoryGirl.create(:user, username: "other", email: "other@email.com")
        expect(@identity).not_to receive(:save!)
        user = User.find_for_oauth(@auth, @other_user)
        expect(user).to eq nil
      end
    end

    describe 'existing user not signed in' do
      before :each do
        @identity = FactoryGirl.create(:identity)
        expect(Identity).to receive(:find_for_oauth).with(@auth).and_return(@identity)
      end
      it 'should save identity to current user if not saved' do
        @other_user = FactoryGirl.create(:user, username: "pan", email: "pamela@malibu.com")
        expect(@identity).to receive(:save!).and_return(true)
        user = User.find_for_oauth(@auth, nil)
        expect(@identity.user).to eq user
        expect(user).to eq @other_user
      end
    end

    describe 'new user' do
      before :each do
        @identity = FactoryGirl.create(:identity)
      end
      it 'should create new user' do
        expect(Identity).to receive(:find_for_oauth).with(@auth).and_return(@identity)
        expect(@identity).to receive(:save!).and_return(true)
        expect(User).to receive(:where).once.ordered.with(email: 'pamela@malibu.com').and_return([])
        expect(User).to receive(:where).once.ordered.with(username: 'pamela').and_return([])
        expect(User).to receive(:new).and_return(@fake_user)
        expect(@fake_user).to receive(:skip_confirmation!)
        expect(@fake_user).to receive(:save!)
        @email_settings = FactoryGirl.create(:email_settings, user: @fake_user)
        expect(EmailSettings).to receive(:create).with(user_id: @fake_user.id).and_return(@email_settings)
        expect(@fake_user).to receive(:notify_user_friends).with(@auth.credentials)
        User.find_for_oauth(@auth, nil)
        expect(@fake_user.email_settings).to eq(@email_settings)
      end
      it 'should create new user with first option username taken' do
        @other_user = FactoryGirl.create(:user, username: "pamela", email: "pam@malibu.com")
        expect(Identity).to receive(:find_for_oauth).with(@auth).and_return(@identity)
        expect(@identity).to receive(:save!).and_return(true)
        expect(User).to receive(:where).once.ordered.with(email: 'pamela@malibu.com').and_return([])
        expect(User).to receive(:where).once.ordered.with(username: 'pamela').and_return([@other_user])
        expect(User).to receive(:where).once.ordered.with(username: 'pamela1').and_return([])
        expect(User).to receive(:new).and_return(@fake_user)
        expect(@fake_user).to receive(:skip_confirmation!)
        expect(@fake_user).to receive(:save!)
        @email_settings = FactoryGirl.create(:email_settings, user: @fake_user)
        expect(EmailSettings).to receive(:create).with(user_id: @fake_user.id).and_return(@email_settings)
        expect(@fake_user).to receive(:notify_user_friends).with(@auth.credentials)
        User.find_for_oauth(@auth, nil)
        expect(@fake_user.email_settings).to eq(@email_settings)
      end
      it 'should create new user non-verified' do
        @auth_unverified = OmniAuth::AuthHash.new({
          :provider => 'fakebook',
          :uid => '92312312',
          :info => {
            :name => 'Pamela Anderson',
            :email => 'pamela@malibu.com'
          }
        })
        expect(Identity).to receive(:find_for_oauth).with(@auth_unverified).and_return(@identity)
        expect(@identity).to receive(:save!).and_return(true)
        expect(User).to receive(:where).once.ordered.with(email: 'pamela@malibu.com').and_return([])
        expect(User).to receive(:where).once.ordered.with(username: 'pamela').and_return([])
        expect(User).to receive(:new).and_return(@fake_user)
        expect(@fake_user).not_to receive(:skip_confirmation!)
        expect(@fake_user).to receive(:save!)
        @email_settings = FactoryGirl.create(:email_settings, user: @fake_user)
        expect(EmailSettings).to receive(:create).with(user_id: @fake_user.id).and_return(@email_settings)
        expect(@fake_user).to receive(:notify_user_friends).with(@auth.credentials)
        User.find_for_oauth(@auth_unverified, nil)
        expect(@fake_user.email_settings).to eq(@email_settings)
      end
    end

  end

  describe 'sorted_battles' do
    it 'should return the battles sorted according to start_at' do
      user = User.create!(@attr)
      e1 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,4,0), :user => user})
      e2 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,2,0), :user => user})
      e3 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,3,0), :user => user})
      expect(user.sorted_battles("1")).to eq([e1, e3, e2])
    end
    it 'should return the battles according to the page' do
      user = User.create!(@attr)
      e1 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,12,0), :user => user})
      e2 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,11,0), :user => user})
      e3 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,10,0), :user => user})
      e4 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,9,0), :user => user})
      e5 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,8,0), :user => user})
      e6 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,7,0), :user => user})
      e7 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,6,0), :user => user})
      e8 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,5,0), :user => user})
      e9 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,4,0), :user => user})
      e10 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,3,0), :user => user})
      e11 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,2,0), :user => user})
      e12 = FactoryGirl.create(:battle, {:starts_at => DateTime.new(2017,3,1,1,0), :user => user})
      expect(user.sorted_battles("1")).to eq([e1, e2, e3, e4, e5])
      expect(user.sorted_battles("2")).to eq([e6, e7, e8, e9, e10])
      expect(user.sorted_battles("3")).to eq([e11, e12])
    end
  end

  describe 'is_friends_with?' do
    before(:each) do
      @friend = FactoryGirl.create(:user)
    end
    it 'should return false if friendship is nil' do
      user = User.create!(@attr)
      expect(user.is_friends_with?(@friend)).to eq(false)
    end
    it 'should return false if user is not following the friend' do
      user = User.create!(@attr)
      not_friend = FactoryGirl.create(:user, email: "not_friend@not_friend.com", username: "not_friend")
      FactoryGirl.create(:friendship, user: user, friend: @friend)
      expect(user.is_friends_with?(not_friend)).to eq(false)
    end
    it 'should return true if user is following the friend' do
      user = User.create!(@attr)
      FactoryGirl.create(:friendship, user: user, friend: @friend)
      expect(user.is_friends_with?(@friend)).to eq(true)
    end
  end

  describe 'get_friendship_with' do
    it 'should return the friendship' do
      user = User.create!(@attr)
      friend = FactoryGirl.create(:user)
      friendship = FactoryGirl.create(:friendship, user: user, friend: friend)
      expect(user.get_friendship_with(friend)).to eq(friendship)
    end
  end

  describe 'votes_for' do
    it 'should return the vote of the user for battle' do
      user = User.create!(@attr)
      other_user = FactoryGirl.create(:user)

      @battle = FactoryGirl.create(:battle,
                                   :starts_at => DateTime.now - 1.day,
                                   :duration => 48*60,
                                   :user => @user)
      @other_battle = FactoryGirl.create(:battle,
                                         :starts_at => DateTime.now - 1.day,
                                         :duration => 48*60,
                                         :user => @user)

      @vote1 = FactoryGirl.create(:vote, user: user, option: @battle.options[0])
      @vote2 = FactoryGirl.create(:vote, user: user, option: @other_battle.options[0])
      @other_vote1 = FactoryGirl.create(:vote, user: other_user, option: @battle.options[0])
      @other_vote2 = FactoryGirl.create(:vote, user: other_user, option: @other_battle.options[1])

      expect(user.vote_for(@battle)).to eq(@vote1)
    end
  end

  describe 'voted_for_options' do
    it 'should return the vote of the user for battle' do
      user = User.create!(@attr)
      other_user = FactoryGirl.create(:user)

      @battle = FactoryGirl.create(:battle,
                                   :starts_at => DateTime.now - 1.day,
                                   :duration => 48*60,
                                   :user => @user)
      @other_battle = FactoryGirl.create(:battle,
                                         :starts_at => DateTime.now - 1.day,
                                         :duration => 48*60,
                                         :user => @user)

      @vote1 = FactoryGirl.create(:vote, user: user, option: @battle.options[0])
      @vote2 = FactoryGirl.create(:vote, user: user, option: @other_battle.options[1])
      @other_vote1 = FactoryGirl.create(:vote, user: other_user, option: @battle.options[0])
      @other_vote2 = FactoryGirl.create(:vote, user: other_user, option: @other_battle.options[0])

      expect(user.voted_for_options([@battle, @other_battle])).to eq({
        @battle.options[0].id => true,
        @battle.options[1].id => false,
        @other_battle.options[0].id => false,
        @other_battle.options[1].id => true
      })
    end
  end

  describe 'receive_vote_notification_from' do
    before :each do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
      battle = FactoryGirl.create(:battle,
                                  :starts_at => DateTime.now - 1.day,
                                  :duration => 48*60,
                                  :user => @user)
      @vote = FactoryGirl.create(:vote, user: @user, option: battle.options[0])
    end
    it 'should create a new Vote Notification' do
      expect(VoteNotification).to receive(:create).with(user: @user, sender: @other_user, vote: @vote)
      @user.receive_vote_notification_from(@other_user, @vote)
    end
    it 'should increment the unread notifications counter' do
      expect(@user).to receive(:increment_unread_notification)
      @user.receive_vote_notification_from(@other_user, @vote)
    end
  end

  describe 'receive_friendship_notification_from' do
    before :each do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
    end
    it 'should create a new Friendship Notification' do
      expect(FriendshipNotification).to receive(:create).with(user: @user, sender: @other_user)
      @user.receive_friendship_notification_from(@other_user)
    end
    it 'should increment the unread notifications counter' do
      expect(@user).to receive(:increment_unread_notification)
      @user.receive_friendship_notification_from(@other_user)
    end
  end

  describe 'receive_facebook_sign_up_notification_from' do
    before :each do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
    end
    it 'should create a new Vote Notification' do
      expect(FacebookSignUpNotification).to receive(:create).with(user: @user, sender: @other_user)
      @user.receive_facebook_sign_up_notification_from(@other_user)
    end
    it 'should increment the unread notifications counter' do
      expect(@user).to receive(:increment_unread_notification)
      @user.receive_facebook_sign_up_notification_from(@other_user)
    end
  end

  describe 'receive_comment_notification_from' do
    before :each do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
      @battle = FactoryGirl.create(:battle,
                                  :starts_at => DateTime.now - 1.day,
                                  :duration => 48*60,
                                  :user => @user)
    end
    it 'should create a new Comment Notification' do
      expect(CommentNotification).to receive(:create).with(user: @user, sender: @other_user, option: @battle.options[0])
      @user.receive_comment_notification_from(@other_user, @battle.options[0])
    end
    it 'should increment the unread notifications counter' do
      expect(@user).to receive(:increment_unread_notification)
      @user.receive_comment_notification_from(@other_user, @battle.options[0])
    end
  end

  describe 'receive_comment_answer_notification_from' do
    before :each do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
      @battle = FactoryGirl.create(:battle,
                                  :starts_at => DateTime.now - 1.day,
                                  :duration => 48*60,
                                  :user => @user)
    end
    it 'should create a new Comment Answer Notification' do
      expect(CommentAnswerNotification).to receive(:create).with(user: @user, sender: @other_user, option: @battle.options[0])
      @user.receive_comment_answer_notification_from(@other_user, @battle.options[0])
    end
    it 'should increment the unread notifications counter' do
      expect(@user).to receive(:increment_unread_notification)
      @user.receive_comment_answer_notification_from(@other_user, @battle.options[0])
    end
  end

  describe 'receive_friendship_email_from' do
    before :each do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
    end
    it 'should create a new friendship email without email_settings' do
      expect(@user).to receive(:email_settings).and_return(nil)
      @friendship_mailer = double("friendship_mailer")
      expect(@friendship_mailer).to receive(:deliver)
      expect(FriendshipMailer).to receive(:new_follower).with(@other_user, @user).and_return(@friendship_mailer)
      @user.receive_friendship_email_from(@other_user)
    end
    it 'should create a new friendship email with email_settings new_follower true' do
      @email_settings = FactoryGirl.create(:email_settings, user: @user, new_follower: true)
      expect(@user).to receive(:email_settings).twice.and_return(@email_settings)
      @friendship_mailer = double("friendship_mailer")
      expect(@friendship_mailer).to receive(:deliver)
      expect(FriendshipMailer).to receive(:new_follower).with(@other_user, @user).and_return(@friendship_mailer)
      @user.receive_friendship_email_from(@other_user)
    end
    it 'should not create a new friendship email with email_settings new_follower false' do
      @email_settings = FactoryGirl.create(:email_settings, user: @user, new_follower: false)
      expect(@user).to receive(:email_settings).twice.and_return(@email_settings)
      expect(FriendshipMailer).not_to receive(:new_follower)
      @user.receive_friendship_email_from(@other_user)
    end
  end

  describe 'receive_facebook_sign_up_email_from' do
    before :each do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
    end
    it 'should create a new friendship email without email_settings' do
      expect(@user).to receive(:email_settings).and_return(nil)
      @friendship_mailer = double("friendship_mailer")
      expect(@friendship_mailer).to receive(:deliver)
      expect(FriendshipMailer).to receive(:facebook_friend_sign_up).with(@other_user, @user).and_return(@friendship_mailer)
      @user.receive_facebook_sign_up_email_from(@other_user)
    end
    it 'should create a new friendship email with email_settings facebook_friend_sign_up true' do
      @email_settings = FactoryGirl.create(:email_settings, user: @user, facebook_friend_sign_up: true)
      expect(@user).to receive(:email_settings).twice.and_return(@email_settings)
      @friendship_mailer = double("friendship_mailer")
      expect(@friendship_mailer).to receive(:deliver)
      expect(FriendshipMailer).to receive(:facebook_friend_sign_up).with(@other_user, @user).and_return(@friendship_mailer)
      @user.receive_facebook_sign_up_email_from(@other_user)
    end
    it 'should not create a new friendship email with email_settings facebook_friend_sign_up false' do
      @email_settings = FactoryGirl.create(:email_settings, user: @user, facebook_friend_sign_up: false)
      expect(@user).to receive(:email_settings).twice.and_return(@email_settings)
      expect(FriendshipMailer).not_to receive(:facebook_friend_sign_up)
      @user.receive_facebook_sign_up_email_from(@other_user)
    end
  end

  describe 'reset_unread_notifications' do
    it 'should update unread_notifications' do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
      expect(@other_user.reset_unread_notifications).to eq(true)
      expect(@other_user.unread_notifications).to eq(0)
    end
  end

  describe 'increment_unread_notifications' do
    it 'should update unread_notifications' do
      @user = User.create!(@attr)
      @other_user = FactoryGirl.create(:user)
      expect(@other_user.increment_unread_notification).to eq(true)
      expect(@other_user.unread_notifications).to eq(1)
      expect(@other_user.increment_unread_notification).to eq(true)
      expect(@other_user.unread_notifications).to eq(2)
    end
  end

  describe 'search' do
    before(:each) do
      @l1 = []
      @l2 = []
      @l3 = []
      @l4 = []
      for i in 1..10 do
        @l1 << FactoryGirl.create(:user, email: "user#{i}@us.com", username: "i_usEr#{i}")
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 11..15 do
        @l2 << FactoryGirl.create(:user, email: "user#{i}@us.com", username: "u_usEr#{i}")
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 16..20 do
        @l3 << FactoryGirl.create(:user, email: "user#{i}@us.com", username: "test#{i}", name: "e_User#{i}")
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 21..25 do
        @l4 << FactoryGirl.create(:user, email: "user#{i}@us.com", username: "test#{i}", name: "i_User#{i}")
        Timecop.travel(Time.now + 1.minute)
      end
    end
    describe 'given search word' do
      it 'should return users from correct page' do
        expect(User.search("user", 1)).to eq(@l1)
        expect(User.search("user", 2)).to eq(@l2.concat(@l3))
        expect(User.search("user", 3)).to eq(@l4)
      end
      it 'should search for usernames' do
        expect(User.search("u_user", 1)).to eq(@l2)
      end
      it 'should search for names' do
        expect(User.search("e_user", 1)).to eq(@l3)
      end
      it 'should search for usernames plus names' do
        expect(User.search("i_user", 1)).to eq(@l1)
        expect(User.search("i_user", 2)).to eq(@l4)
      end
    end
    describe 'no given search word' do
      it 'should return users from correct page' do
        expect(User.search(nil, 2)).to eq(@l2.concat(@l3))
      end
    end
  end

  describe 'following' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should return the ordered votes from correct page' do
      @l1 = []
      @l2 = []
      @l3 = []
      @l1 << FactoryGirl.create(:user, {username: "u1", email: "u1@email.com"})
      @l1 << FactoryGirl.create(:user, {username: "u10", email: "u10@email.com"})
      for i in 2..9 do
        @l1 << FactoryGirl.create(:user, {username: "u#{i}", email: "u#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 11..20 do
        @l2 << FactoryGirl.create(:user, {username: "a#{i}", email: "a#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 11..20 do
        @l3 << FactoryGirl.create(:user, {username: "x#{i}", email: "x#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end

      @l1.each do |friend|
        FactoryGirl.create(:friendship, user: @user, friend: friend)
      end
      @l2.each do |friend|
        FactoryGirl.create(:friendship, user: @user, friend: friend)
      end
      @l3.each do |friend|
        FactoryGirl.create(:friendship, user: @user, friend: friend)
      end

      expect(@user.following("2")).to eq(@l1)
    end
  end

  describe 'followers' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should return the ordered votes from correct page' do
      @l1 = []
      @l2 = []
      @l3 = []
      @l1 << FactoryGirl.create(:user, {username: "u1", email: "u1@email.com"})
      @l1 << FactoryGirl.create(:user, {username: "u10", email: "u10@email.com"})
      for i in 2..9 do
        @l1 << FactoryGirl.create(:user, {username: "u#{i}", email: "u#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 11..19 do
        @l2 << FactoryGirl.create(:user, {username: "x#{i}", email: "x#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 11..20 do
        @l3 << FactoryGirl.create(:user, {username: "a#{i}", email: "a#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end

      @l1.each do |friend|
        FactoryGirl.create(:friendship, user: friend, friend: @user)
      end
      @l2.each do |friend|
        FactoryGirl.create(:friendship, user: friend, friend: @user)
      end
      @l3.each do |friend|
        FactoryGirl.create(:friendship, user: friend, friend: @user)
      end

      expect(@user.followers("3")).to eq(@l2)
    end
  end

  describe 'get_facebook_friends' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should return the ordered votes from correct page' do
      @l1 = []
      @l2 = []
      @l3 = []
      @l1 << FactoryGirl.create(:user, {username: "u1", email: "u1@email.com"})
      @l1 << FactoryGirl.create(:user, {username: "u10", email: "u10@email.com"})
      for i in 2..9 do
        @l1 << FactoryGirl.create(:user, {username: "u#{i}", email: "u#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 11..19 do
        @l2 << FactoryGirl.create(:user, {username: "x#{i}", email: "x#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 11..20 do
        @l3 << FactoryGirl.create(:user, {username: "a#{i}", email: "a#{i}@email.com"})
        Timecop.travel(Time.now + 1.minute)
      end

      @l1.each do |friend|
        FactoryGirl.create(:facebook_friendship, user: @user, facebook_friend: friend)
      end
      @l2.each do |friend|
        FactoryGirl.create(:facebook_friendship, user: @user, facebook_friend: friend)
      end
      @l3.each do |friend|
        FactoryGirl.create(:facebook_friendship, user: @user, facebook_friend: friend)
      end

      expect(@user.get_facebook_friends("3")).to eq(@l2)
    end
  end

  describe 'connected_to_facebook?' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should return true when an identity from facebook is found' do
      @identity = FactoryGirl.create(:identity, {user: @user, provider: 'facebook'})
      expect(@user.connected_to_facebook?).to eq(true)
    end
    it 'should return false when an identity from facebook is not found' do
      @identity = FactoryGirl.create(:identity, {user: @user, provider: 'twitter'})
      expect(@user.connected_to_facebook?).to eq(false)
    end
  end

  describe 'has_friendship_with' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should be true if user is following friend' do
      @friend = FactoryGirl.create(:user, {username: "friend", email: "friend@email.com"})
      FactoryGirl.create(:friendship, user: @user, friend: @friend)
      expect(@user.has_friendship_with(@friend)).to be(true)
    end
    it 'should be false if user is following friend' do
      @friend = FactoryGirl.create(:user, {username: "friend", email: "friend@email.com"})
      expect(@user.has_friendship_with(@friend)).to be(false)
    end
  end

  describe 'has_facebook_friendship_with' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should be true if user is following friend' do
      @friend = FactoryGirl.create(:user, {username: "friend", email: "friend@email.com"})
      FactoryGirl.create(:facebook_friendship, user: @user, facebook_friend: @friend)
      expect(@user.has_facebook_friendship_with(@friend)).to be(true)
    end
    it 'should be false if user is following friend' do
      @friend = FactoryGirl.create(:user, {username: "friend", email: "friend@email.com"})
      expect(@user.has_facebook_friendship_with(@friend)).to be(false)
    end
  end

  describe 'update_facebook_friend' do
    before(:each) do
      @user = User.new(@attr)
      @friend = FactoryGirl.create(:user, {username: "friend", email: "friend@email.com"})
    end
    it 'should add Facebook friend with no errors' do
      expect(Identity).to receive(:search_friend).with("09434", "facebook").and_return(@friend)
      @facebook_friendships = double('facebook_friendships')
      expect(@facebook_friendships).to receive(:create).and_return(true)
      expect(@user).to receive(:facebook_friendships).and_return(@facebook_friendships)
      expect(@user).to receive(:has_friendship_with).and_return(false)
      expect(@user).to receive(:has_facebook_friendship_with).and_return(false)
      expect(@user.update_facebook_friend({"id" => "09434"})).to eq(true)
    end
    it 'should not add Facebook friend not found' do
      expect(Identity).to receive(:search_friend).with("09434", "facebook").and_return(nil)
      expect(@user).not_to receive(:facebook_friendships)
      expect(@user.update_facebook_friend({"id" => "09434"})).to eq(false)
    end
    it 'should not add Facebook friend already added' do
      expect(Identity).to receive(:search_friend).with("09434", "facebook").and_return(@friend)
      expect(@user).to receive(:has_friendship_with).twice.with(@friend).and_return(true)
      expect(@user).to receive(:has_facebook_friendship_with).and_return(false)
      expect(@user).not_to receive(:facebook_friendships)
      expect(@user.update_facebook_friend({"id" => "09434"})).to eq(false)
    end
    it 'should not add Facebook friend already Facebook followed' do
      expect(Identity).to receive(:search_friend).with("09434", "facebook").and_return(@friend)
      expect(@user).to receive(:has_friendship_with).twice.with(@friend).and_return(false)
      expect(@user).to receive(:has_facebook_friendship_with).with(@friend).and_return(true)
      expect(@user).not_to receive(:facebook_friendships)
      expect(@user.update_facebook_friend({"id" => "09434"})).to eq(false)
    end
    it 'should remove Facebook friend already followed' do
      expect(Identity).to receive(:search_friend).with("09434", "facebook").and_return(@friend)
      @facebook_friendships = double('facebook_friendships')
      @facebook_friendship = double('facebook_friendship')
      expect(@facebook_friendship).to receive(:destroy).and_return(true)
      expect(@facebook_friendships).to receive(:where).with(facebook_friend_id: @friend.id).and_return([@facebook_friendship])
      expect(@user).to receive(:facebook_friendships).and_return(@facebook_friendships)
      expect(@user).to receive(:has_friendship_with).twice.with(@friend).and_return(true)
      expect(@user).to receive(:has_facebook_friendship_with).and_return(true)
      expect(@user.update_facebook_friend({"id" => "09434"})).to eq(true)
    end
  end

  describe 'notify_user_friends' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should notify list of friends' do
      @graph = double("graph")
      @friend1 = double("friend1")
      @friend2 = double("friend2")
      @friends = [ @friend1, @friend2 ]
      expect(@user).to receive(:find_friends_from_facebook).with("credentials").and_return(@friends)
      expect(@user).to receive(:update_facebook_friend).with(@friend1)
      expect(@user).to receive(:update_facebook_friend).with(@friend2)

      @friend = FactoryGirl.create(:user, {username: "friend", email: "friend@email.com"})
      @friendship1 = FactoryGirl.create(:facebook_friendship, user: @user, facebook_friend: @friend)
      expect(@friend).to receive(:receive_facebook_sign_up_notification_from).with(@user)
      expect(@friend).to receive(:receive_facebook_sign_up_email_from).with(@user)
      expect(@user).to receive(:facebook_friendships).and_return([@friendship1])

      @user.notify_user_friends("credentials")
    end
    it 'should do nothing without credentials' do
      expect(@user).not_to receive(:find_friends_from_facebook)
      expect(@user).not_to receive(:update_facebook_friend)
      expect(@user).not_to receive(:facebook_friendships)

      @user.notify_user_friends(nil)
    end
  end

  describe 'find_friends_from_facebook' do
    before(:each) do
      @user = User.new(@attr)
    end
    it 'should get friend list from Facebook' do
      @graph = double("graph")
      @friend1 = double("friend1")
      @friend2 = double("friend2")
      @friends = [ @friend1, @friend2 ]
      expect(@graph).to receive(:get_connections).with("me", "friends").and_return(@friends)
      expect(Koala::Facebook::API).to receive(:new).with('ABCDEFG').and_return(@graph)
      @credentials = double("credentials")
      expect(@credentials).to receive(:token).and_return("ABCDEFG")
      expect(@user.find_friends_from_facebook(@credentials)).to eq(@friends)
    end
  end

  describe 'welcome?' do
    before(:each) do
      @user = User.new(@attr)
      @fake_friends = double('friends')
      expect(@user).to receive(:friends).and_return(@fake_friends)
    end
    it 'should return true when user has less than 4 friends' do
      expect(@fake_friends).to receive(:count).and_return(1)
      expect(@user.welcome?).to eq(true)
    end
    it 'should return true when user has 4 friends' do
      expect(@fake_friends).to receive(:count).and_return(4)
      expect(@user.welcome?).to eq(true)
    end
    it 'should return false when user has more than 4 friends' do
      expect(@fake_friends).to receive(:count).and_return(5)
      expect(@user.welcome?).to eq(false)
    end
  end

  describe 'first_battle?' do
    before(:each) do
      @user = User.new(@attr)
      @fake_battles = double('battles')
      expect(@user).to receive(:battles).and_return(@fake_battles)
    end
    it 'should return true when user has 0 battles' do
      expect(@fake_battles).to receive(:count).and_return(0)
      expect(@user.first_battle?).to eq(true)
    end
    it 'should return false when user has more than 0 battles' do
      expect(@fake_battles).to receive(:count).and_return(1)
      expect(@user.first_battle?).to eq(false)
    end
  end
end
