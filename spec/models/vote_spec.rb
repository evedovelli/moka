require 'rails_helper'

describe Vote do
  before(:each) do
    @battle = FactoryGirl.create(:battle, {
      :starts_at   => DateTime.now - 1.day,
      :finishes_at => DateTime.now + 1.day
    })
    @attr = {
      :option => @battle.options[0]
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
  end

  describe 'validates posts created in wrong period' do
    it 'should fails when post is created to a finished battle' do
      @battle = FactoryGirl.create(:battle, {
        :starts_at   => DateTime.now - 2.day,
        :finishes_at => DateTime.now - 1.day
      })
      @attr = {
        :option => @battle.options[0]
      }
      vote = Vote.new(@attr)
      vote.save()
      expect(vote).not_to be_valid
    end
    it 'should fails when post is created to a not started battle' do
      @battle = FactoryGirl.create(:battle, {
        :starts_at   => DateTime.now + 2.day,
        :finishes_at => DateTime.now + 4.day
      })
      @attr = {
        :option => @battle.options[0]
      }
      vote = Vote.new(@attr)
      vote.save()
      expect(vote).not_to be_valid
    end
    it 'should be ok when post is created during battle' do
      @battle = FactoryGirl.create(:battle, {
        :starts_at   => DateTime.now - 2.day,
        :finishes_at => DateTime.now + 2.day
      })
      @attr = {
        :option => @battle.options[0]
      }
      vote = Vote.new(@attr)
      vote.save()
      expect(vote).to be_valid
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
