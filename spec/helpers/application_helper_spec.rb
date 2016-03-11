require "rails_helper"

describe ApplicationHelper, :type => :helper do
  describe "is_active?" do
    it "should return active when path matches current path" do
      expect(view).to receive(:current_page?).and_return(true)
      expect(helper.is_active?("path")).to eql("active")
    end
    it "should return nothing when path does not match current path" do
      expect(view).to receive(:current_page?).and_return(false)
      expect(helper.is_active?("path")).to eql(nil)
    end
  end
end
