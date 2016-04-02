require 'rails_helper'

describe Option do
  before(:each) do
    @attr = {
      :name => "Chips",
      :picture => File.new(Rails.root + 'spec/fixtures/images/chips.png')
    }
  end

  it "should create a new instance given a valid set of attributes" do
    option = Option.new(@attr)
    expect(option).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when name is empty' do
      @attr.delete(:name)
      option = Option.new(@attr)
      expect(option).not_to be_valid
    end
    it 'should fails when picture is empty' do
      @attr.delete(:picture)
      option = Option.new(@attr)
      expect(option).not_to be_valid
    end
  end

  describe 'validate name length' do
    it 'should fails when over 40 chars' do
      option = Option.new(@attr.merge(:name => 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'))
      expect(option).not_to be_valid
    end
    it 'should pass when exactly 40 chars' do
      option = Option.new(@attr.merge(:name => 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'))
      expect(option).to be_valid
    end
    it 'should pass with small length' do
      option = Option.new(@attr.merge(:name => 'yyyyyyyyy'))
      expect(option).to be_valid
    end
  end

  describe 'validates attached picture' do
    it 'should validates attachment content type' do
      option = Option.new(@attr.merge(:picture => File.new(Rails.root + 'spec/fixtures/images/no_image.txt')))
      expect(option).not_to be_valid
    end
  end

  describe "destroy" do
    before(:each) do
      @option = Option.new(@attr)
      @user = FactoryGirl.create(:user)
      @other_user = FactoryGirl.create(:user, username: "patty", email: "patty@peppermint.com")
      @battle = FactoryGirl.create(:battle,
                                   :starts_at => DateTime.now - 1.day,
                                   :duration => 48*60,
                                   :user => @user)
      @battle.options << @option
    end
    it "should destroy options's votes" do
      FactoryGirl.create(:vote, user: @user, option: @option)
      FactoryGirl.create(:vote, user: @other_user, option: @option)
      expect{ @option.destroy }.to change{ Vote.count }.by(-2)
    end
  end

  describe 'number of votes' do
    it 'should return the number of votes for this option' do
      option = Option.new(@attr)
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u1", email: "u1@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u2", email: "u2@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u3", email: "u3@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u4", email: "u4@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u5", email: "u5@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u6", email: "u6@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u7", email: "u7@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u8", email: "u8@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u9", email: "u9@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u10", email: "u10@email.com"})})
      votes = FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u11", email: "u11@email.com"})})
      expect(option.number_of_votes).to eq(11)
    end
  end

  describe 'ordered votes' do
    it 'should return the ordered votes from correct page' do
      @l1 = []
      @l2 = []
      option = Option.new(@attr)
      for i in 1..15 do
        @l1 << FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u#{i}", email: "u#{i}@email.com"})})
        Timecop.travel(Time.now + 1.minute)
      end
      for i in 16..25 do
        @l2 << FactoryGirl.create(:vote, {option: option, user: FactoryGirl.create(:user, {username: "u#{i}", email: "u#{i}@email.com"})})
        Timecop.travel(Time.now + 1.minute)
      end
      expect(option.ordered_votes("2")).to eq(@l2)
    end
  end

end
