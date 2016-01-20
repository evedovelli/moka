require "spec_helper"

describe VotesHelper, :type => :helper do
  describe "votes size" do
    it "should return biggest when percentage is over 75%" do
      expect(helper.votes_size(151, 200)).to eq("vote-size-biggest")
    end
    it "should return big when percentage is equal to 75%" do
      expect(helper.votes_size(150, 200)).to eq("vote-size-big")
    end
    it "should return big when percentage is under 75% and over 50%" do
      expect(helper.votes_size(101, 200)).to eq("vote-size-big")
    end
    it "should return medium when percentage is equal to 50%" do
      expect(helper.votes_size(100, 200)).to eq("vote-size-medium")
    end
    it "should return medium when percentage is under 50% and over 30%" do
      expect(helper.votes_size(61, 200)).to eq("vote-size-medium")
    end
    it "should return small when percentage is equal to 30%" do
      expect(helper.votes_size(60, 200)).to eq("vote-size-small")
    end
    it "should return small when percentage is under 30% and over 15%" do
      expect(helper.votes_size(31, 200)).to eq("vote-size-small")
    end
    it "should return smallest when percentage is equal to 15%" do
      expect(helper.votes_size(30, 200)).to eq("vote-size-smallest")
    end
    it "should return smallest when percentage is unde 15%" do
      expect(helper.votes_size(0, 200)).to eq("vote-size-smallest")
    end
  end
end
