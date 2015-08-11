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
    User.create!(@attr)
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
      @email = "foo@bar.com"
      @warden_conditions = { :login => @email }
    end
    it "should finds user by email" do
      user = FactoryGirl.create(:user, email: @email)
      authenticated = User.find_for_database_authentication(@warden_conditions)
      expect(authenticated).to eql(user)
    end
    it "should finds user by username" do
      user = FactoryGirl.create(:user, username: @email)
      authenticated = User.find_for_database_authentication(@warden_conditions)
      expect(authenticated).to eql(user)
    end
    it "should finds without login" do
      user = FactoryGirl.create(:user, email: @email)
      @warden_conditions = { :email => @email }
      authenticated = User.find_for_database_authentication(@warden_conditions)
      expect(authenticated).to eql(user)
    end
  end

  describe 'username' do
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
  end

  describe 'to_param' do
    it 'should return the username' do
      user = User.create!(@attr)
      expect(user.to_param).to eq("testuser")
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

end
