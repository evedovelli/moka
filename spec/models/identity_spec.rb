require 'rails_helper'

describe Identity do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = {
      :provider => "batalharia",
      :uid => "98234"
    }
  end

  it "should create a new instance given a valid set of attributes" do
    identity = Identity.new(@attr)
    expect(identity).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when provider is empty' do
      @attr.delete(:provider)
      identity = Identity.new(@attr)
      expect(identity).not_to be_valid
    end
    it 'should fails when uid is empty' do
      @attr.delete(:uid)
      identity = Identity.new(@attr)
      expect(identity).not_to be_valid
    end
  end

  describe 'validates uniqueness of uid for a provider' do
    it 'should fails when uid is already used for a provider' do
      i = Identity.new(@attr)
      i.save()
      identity = Identity.new(@attr)
      identity.save()
      expect(identity).not_to be_valid
    end
    it 'should be valid when uid is repeated but for other provider' do
      i = Identity.new(@attr)
      i.save()
      identity = Identity.new(@attr.merge(provider: "facebook"))
      identity.save()
      expect(identity).to be_valid
    end
  end

  describe 'find for oauth' do
    it 'should find the existing identity' do
      i = Identity.new(@attr)
      i.save
      @auth = OmniAuth::AuthHash.new({
        :provider => @attr[:provider],
        :uid => @attr[:uid]
      })
      identity = Identity.find_for_oauth(@auth)
      expect(identity).to eq(i)
    end
    it 'should create a new identity when none is found' do
      @auth = OmniAuth::AuthHash.new({
        :provider => @attr[:provider],
        :uid => @attr[:uid]
      })
      identity = Identity.find_for_oauth(@auth)
      expect(identity).to be_valid
    end
  end

  describe 'search_friend' do
    before :each do
      @id1 = Identity.new({
        :provider => "twitter",
        :uid => "98234"
      })
      @id1.save
      @user.identities << @id1
      @user.save

      @id2 = Identity.new({
        :provider => "facebook",
        :uid => "08234"
      })
      @id2.save
      @user.identities << @id2
      @user.save
    end
    it 'should return identity of friend when found' do
      friend = Identity.search_friend("08234", "facebook")
      expect(friend).to eq(@user)
    end
    it 'should return nil when uid is not found' do
      friend = Identity.search_friend("01234", "facebook")
      expect(friend).to be_nil
    end
    it 'should return nil when provider is not found' do
      friend = Identity.search_friend("98234", "instagram")
      expect(friend).to be_nil
    end
  end
end
