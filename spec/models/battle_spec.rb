require 'rails_helper'

describe Battle do
  before(:each) do
    @b1 = FactoryGirl.create(:option, :name => "Beetle")
    @b2 = FactoryGirl.create(:option, :name => "Juice")
    @user = FactoryGirl.create(:user)
    @attr = {
      :options => [@b1, @b2],
      :starts_at => DateTime.now,
      :duration => '60',
      :title => 'Why?',
      :user => @user
    }
  end

  it "should create a new instance given a valid set of attributes" do
    battle = Battle.new(@attr)
    expect(battle).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when starts_at is empty' do
      @attr.delete(:starts_at)
      battle = Battle.new(@attr)
      expect(battle).not_to be_valid
    end
    it 'should fails when user is empty' do
      @attr.delete(:user)
      battle = Battle.new(@attr)
      expect(battle).not_to be_valid
    end
  end

  describe 'validates number of options' do
    it 'should fails when number of options is less than 2' do
      battle = Battle.new(@attr.merge(:options => [@b1]))
      expect(battle).not_to be_valid
    end
    it 'should be ok when number of options is equal to 2' do
      battle = Battle.new(@attr.merge(:options => [@b1, @b2]))
      expect(battle).to be_valid
    end
    it 'should be ok when number of options is greater than 2 and smaller than 6' do
      @b3 = FactoryGirl.create(:option, :name => "Bruni")
      @b4 = FactoryGirl.create(:option, :name => "Bruni")
      battle = Battle.new(@attr.merge(:options => [@b1, @b2, @b3, @b4]))
      expect(battle).to be_valid
    end
    it 'should be ok when number of options is equal to 6' do
      @b3 = FactoryGirl.create(:option, :name => "Bruni")
      @b4 = FactoryGirl.create(:option, :name => "Bruni")
      @b5 = FactoryGirl.create(:option, :name => "Bruni")
      @b6 = FactoryGirl.create(:option, :name => "Bruni")
      battle = Battle.new(@attr.merge(:options => [@b1, @b2, @b3, @b4, @b5, @b6]))
      expect(battle).to be_valid
    end
    it 'should fails when number of options is greater than 6' do
      @b3 = FactoryGirl.create(:option, :name => "Bruni")
      @b4 = FactoryGirl.create(:option, :name => "Bruni")
      @b5 = FactoryGirl.create(:option, :name => "Bruni")
      @b6 = FactoryGirl.create(:option, :name => "Bruni")
      @b7 = FactoryGirl.create(:option, :name => "Bruni")
      battle = Battle.new(@attr.merge(:options => [@b1, @b2, @b3, @b4, @b5, @b6, @b7]))
      expect(battle).not_to be_valid
    end
  end

  describe 'validate duration numericality' do
    it 'should fails for non integer' do
      battle = Battle.new(@attr.merge(:duration => '7.34'))
      expect(battle).not_to be_valid
    end
    it 'should fails for 0' do
      battle = Battle.new(@attr.merge(:duration => '0'))
      expect(battle).not_to be_valid
    end
    it 'should fails for negative values' do
      battle = Battle.new(@attr.merge(:duration => '-10'))
      expect(battle).not_to be_valid
    end
  end

  describe 'hide' do
    it 'should make the battle hidden' do
      battle = Battle.new(@attr)
      expect(battle.hidden).to equal(false)
      battle.hide
      expect(battle.hidden).to equal(true)
    end
  end

  describe 'user_home' do
    before(:each) do
      @u1 = FactoryGirl.create(:user, email: "u1@u1.com", username: "u1")
      @u2 = FactoryGirl.create(:user, email: "u2@u2.com", username: "u2")
      @u3 = FactoryGirl.create(:user, email: "u3@u3.com", username: "u3")
      @user = FactoryGirl.create(:user, email: "user@user.com", username: "user")
      FactoryGirl.create(:friendship, user: @user, friend: @u1)
      FactoryGirl.create(:friendship, user: @user, friend: @u2)
    end
    it 'should return the battles sorted according to start_at' do
      e1 = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,4,0))
      e2 = FactoryGirl.create(:battle, :user => @u2, :starts_at => DateTime.new(2017,3,1,2,0))
      e3 = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,3,0))
      expect(Battle.user_home(@user, "1")).to eq([e1, e3, e2])
    end
    it 'should return the battles according to the page' do
      e1  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,12,0))
      e2  = FactoryGirl.create(:battle, :user => @u2, :starts_at => DateTime.new(2017,3,1,11,0))
      e3  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,10,0))
      e4  = FactoryGirl.create(:battle, :user => @u2, :starts_at => DateTime.new(2017,3,1,9,0))
      e5  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,8,0))
      e6  = FactoryGirl.create(:battle, :user => @user, :starts_at => DateTime.new(2017,3,1,7,0))
      e7  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,6,0))
      e8  = FactoryGirl.create(:battle, :user => @u2, :starts_at => DateTime.new(2017,3,1,5,0))
      e9  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,4,0))
      e10 = FactoryGirl.create(:battle, :user => @user, :starts_at => DateTime.new(2017,3,1,3,0))
      e11 = FactoryGirl.create(:battle, :user => @u2, :starts_at => DateTime.new(2017,3,1,2,0))
      e12 = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,1,0))
      expect(Battle.user_home(@user, "1")).to eq([e1, e2, e3, e4, e5])
      expect(Battle.user_home(@user, "2")).to eq([e6, e7, e8, e9, e10])
      expect(Battle.user_home(@user, "3")).to eq([e11, e12])
    end
    it 'should return the battles only from following' do
      e1  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,12,0))
      e2  = FactoryGirl.create(:battle, :user => @u3, :starts_at => DateTime.new(2017,3,1,11,0))
      e3  = FactoryGirl.create(:battle, :user => @u2, :starts_at => DateTime.new(2017,3,1,10,0))
      e4  = FactoryGirl.create(:battle, :user => @u3, :starts_at => DateTime.new(2017,3,1,9,0))
      e5  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,8,0))
      e6  = FactoryGirl.create(:battle, :user => @user, :starts_at => DateTime.new(2017,3,1,7,0))
      e7  = FactoryGirl.create(:battle, :user => @u3, :starts_at => DateTime.new(2017,3,1,6,0))
      expect(Battle.user_home(@user, "1")).to eq([e1, e3, e5, e6])
    end
    it 'should return no battles if not following anyone' do
      e1  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,12,0))
      e2  = FactoryGirl.create(:battle, :user => @u3, :starts_at => DateTime.new(2017,3,1,11,0))
      e3  = FactoryGirl.create(:battle, :user => @user, :starts_at => DateTime.new(2017,3,1,10,0))
      e4  = FactoryGirl.create(:battle, :user => @u3, :starts_at => DateTime.new(2017,3,1,9,0))
      e5  = FactoryGirl.create(:battle, :user => @u1, :starts_at => DateTime.new(2017,3,1,8,0))
      e6  = FactoryGirl.create(:battle, :user => @user, :starts_at => DateTime.new(2017,3,1,7,0))
      e7  = FactoryGirl.create(:battle, :user => @u3, :starts_at => DateTime.new(2017,3,1,6,0))
      expect(Battle.user_home(@u2, "1")).to eq([])
    end
  end

  describe 'current?' do
    it 'should return true if battle is on air' do
      battle = Battle.new(@attr)
      allow(battle).to receive(:starts_at).and_return(DateTime.new(2017,3,1,2,0))
      allow(battle).to receive(:duration).and_return(60)
      allow(DateTime).to receive(:current).and_return(DateTime.new(2017,3,1,2,30))
      expect(battle.current?).to eq(true)
    end
    it 'should return false if battle is not started' do
      battle = Battle.new(@attr)
      allow(battle).to receive(:starts_at).and_return(DateTime.new(2017,3,1,2,0))
      allow(battle).to receive(:duration).and_return(60)
      allow(DateTime).to receive(:current).and_return(DateTime.new(2017,3,1,1,30))
      expect(battle.current?).to eq(false)
    end
    it 'should return false if battle is finished' do
      battle = Battle.new(@attr)
      allow(battle).to receive(:starts_at).and_return(DateTime.new(2017,3,1,2,0))
      allow(battle).to receive(:duration).and_return(60)
      allow(DateTime).to receive(:current).and_return(DateTime.new(2017,3,1,3,30))
      expect(battle.current?).to eq(false)
    end
  end

  describe 'in_future?' do
    it 'should return true if battle will happen in future' do
      Timecop.freeze(Time.local(2001))
      battle = Battle.new(@attr.merge(
                                      :starts_at => DateTime.now + 1.hour,
                                      :duration => 3*24*60
                                     ))
      expect(battle.in_future?).to eq(true)
    end
    it 'should return false if battle will happen in future' do
      Timecop.freeze(Time.local(2001))
      battle = Battle.new(@attr.merge(
                                      :starts_at => DateTime.now - 1.day,
                                      :duration => 20*60
                                     ))
      expect(battle.in_future?).to eq(false)
    end
  end

  describe 'finishes_at' do
    it 'should return the date due to finish the battle' do
      Timecop.freeze(Time.local(2001))
      battle = Battle.new(@attr.merge(
                                      :starts_at => DateTime.now + 1.hour,
                                      :duration => 60
                                     ))
      expect(battle.finishes_at).to eq(DateTime.now + 2.hours)
    end
  end

end
