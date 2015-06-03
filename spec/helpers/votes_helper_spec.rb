require "spec_helper"

describe VotesHelper, :type => :helper do
  describe "get option span poll" do
    it "should return span4 offset1 for 1st option with 2 options" do
      expect(helper.get_option_span_poll(2, 1)).to eq("span4 offset1")
    end
    it "should return span4 offset2 for 2nd option with 2 options" do
      expect(helper.get_option_span_poll(2, 2)).to eq("span4 offset2")
    end
    it "should return span4 with 3 options" do
      expect(helper.get_option_span_poll(3, 1)).to eq("span4")
      expect(helper.get_option_span_poll(3, 2)).to eq("span4")
      expect(helper.get_option_span_poll(3, 3)).to eq("span4")
    end
    it "should return span4 offset1 for 1st and 3rd option with 4 options" do
      expect(helper.get_option_span_poll(4, 1)).to eq("span4 offset1")
      expect(helper.get_option_span_poll(4, 3)).to eq("span4 offset1")
    end
    it "should return span4 offset2 for other options with 4 options" do
      expect(helper.get_option_span_poll(4, 2)).to eq("span4 offset2")
      expect(helper.get_option_span_poll(4, 4)).to eq("span4 offset2")
    end
    it "should return span4 for more than 4 options" do
      expect(helper.get_option_span_poll(5, 2)).to eq("span4")
    end
  end
end
