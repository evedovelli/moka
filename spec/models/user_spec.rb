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


end
