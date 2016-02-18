require "rails_helper"

describe OptionsHelper, :type => :helper do
  describe "fill if voted" do
    it "should return empty if no votes" do
      expect(helper.fill_if_voted(1, "voted")).to eq("")
    end
    it "should return empty if no vote for option" do
      @voted_for = {
        1 => false,
        2 => true
      }
      expect(helper.fill_if_voted(1, "voted")).to eq("")
    end
    it "should return the contents if there is vote for option" do
      @voted_for = {
        1 => false,
        2 => true
      }
      expect(helper.fill_if_voted(2, "voted")).to eq("voted")
    end
  end
  describe "fill if victorious" do
    it "should return empty if no victorious" do
      expect(helper.fill_if_victorious(1, "victorious", false)).to eq("")
    end
    it "should return empty if no victorious for option" do
      @victorious = {
        1 => false,
        2 => true
      }
      expect(helper.fill_if_victorious(1, "victorious", false)).to eq("")
    end
    it "should return empty if current flag" do
      @victorious = {
        1 => true,
        2 => true
      }
      expect(helper.fill_if_victorious(1, "victorious", true)).to eq("")
    end
    it "should return the contents if option is victorious" do
      @victorious = {
        1 => false,
        2 => true
      }
      expect(helper.fill_if_victorious(2, "victorious", false)).to eq("victorious")
    end
  end
end
