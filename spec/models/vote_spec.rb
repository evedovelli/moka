require 'rails_helper'

describe Vote do
  before(:each) do
    @battle = FactoryGirl.create(:battle, {
      :starts_at => DateTime.now - 1.day,
      :duration => 48*60
    })
    @user = FactoryGirl.create(:user, {username: "user", email: "user@user.com"})
    @attr = {
      :option => @battle.options[0],
      :user => @user
    }
  end

  it "should create a new instance given a valid set of attributes" do
    vote = Vote.new(@attr)
    expect(vote).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when option is empty' do
      @attr.delete(:option)
      vote = Vote.new(@attr)
      expect(vote).not_to be_valid
    end
    it 'should fails when user is empty' do
      @attr.delete(:user)
      vote = Vote.new(@attr)
      expect(vote).not_to be_valid
    end
  end

  describe 'validates vote created in wrong period' do
    it 'should fails when vote is created to a finished battle' do
      @battle = FactoryGirl.create(:battle, {
        :starts_at   => DateTime.now - 2.day,
        :duration => 24*60
      })
      @attr = {
        :option => @battle.options[0],
        :user => @user
      }
      vote = Vote.new(@attr)
      expect(vote).not_to be_valid
    end
    it 'should fails when vote is created to a not started battle' do
      @battle = FactoryGirl.create(:battle, {
        :starts_at   => DateTime.now + 2.day,
        :duration => 48*60
      })
      @attr = {
        :option => @battle.options[0],
        :user => @user
      }
      vote = Vote.new(@attr)
      expect(vote).not_to be_valid
    end
    it 'should be ok when vote is created during battle' do
      @battle = FactoryGirl.create(:battle, {
        :starts_at   => DateTime.now - 2.day,
        :duration => 96*60
      })
      @attr = {
        :option => @battle.options[0],
        :user => @user
      }
      vote = Vote.new(@attr)
      expect(vote).to be_valid
    end
  end

  describe 'validates single vote per battle' do
    it 'should fails when user creates more than one vote for a battle' do
      vote = Vote.new(@attr)
      expect(vote).to be_valid
      expect(vote.save).to eq(true)

      @attr = {
        :option => @battle.options[1],
      }
      vote = Vote.new(@attr)
      expect(vote).not_to be_valid
    end
  end

  describe 'error message' do
    it "should create an error message from the list of errors" do
      @vote = Vote.new(@attr)
      @errors = double("Errors")
      allow(@errors).to receive(:full_messages).and_return(["Message1", "Message2", "Message3"])
      allow(@vote).to receive(:errors).and_return(@errors)

      expect(@vote.error_message).to eq(" Message1; Message2; Message3.")
    end
  end

end
