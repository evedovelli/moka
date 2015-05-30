require 'rails_helper'

describe Vote do
  before(:each) do
    @contest = FactoryGirl.create(:contest, {
      :starts_at   => DateTime.now - 1.day,
      :finishes_at => DateTime.now + 1.day
    })
    @attr = {
      :stuff => @contest.stuffs[0],
      :contest => @contest,
    }
  end

  it "should create a new instance given a valid set of attributes" do
    vote = Vote.new(@attr)
    expect(vote).to be_valid
  end

  describe 'validates presence of required attributes' do
    it 'should fails when stuff is empty' do
      @attr.delete(:stuff)
      vote = Vote.new(@attr)
      expect(vote).not_to be_valid
    end
    it 'should fails when contest is empty' do
      @attr.delete(:contest)
      vote = Vote.new(@attr)
      expect(vote).not_to be_valid
    end
  end

  describe 'validates if stuff belongs to contest' do
    it 'should fails when stuff does not belong to contest' do
      vote = Vote.new(@attr.merge(:stuff => FactoryGirl.create(:stuff)))
      expect(vote).not_to be_valid
    end
  end

  describe 'validates posts created in wrong period' do
    it 'should fails when post is created to a finished contest' do
      @contest = FactoryGirl.create(:contest, {
        :starts_at   => DateTime.now - 2.day,
        :finishes_at => DateTime.now - 1.day
      })
      @attr = {
        :stuff => @contest.stuffs[0],
        :contest => @contest,
      }
      vote = Vote.new(@attr)
      vote.save()
      expect(vote).not_to be_valid
    end
    it 'should fails when post is created to a not started contest' do
      @contest = FactoryGirl.create(:contest, {
        :starts_at   => DateTime.now + 2.day,
        :finishes_at => DateTime.now + 4.day
      })
      @attr = {
        :stuff => @contest.stuffs[0],
        :contest => @contest,
      }
      vote = Vote.new(@attr)
      vote.save()
      expect(vote).not_to be_valid
    end
    it 'should be ok when post is created during contest' do
      @contest = FactoryGirl.create(:contest, {
        :starts_at   => DateTime.now - 2.day,
        :finishes_at => DateTime.now + 2.day
      })
      @attr = {
        :stuff => @contest.stuffs[0],
        :contest => @contest,
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
