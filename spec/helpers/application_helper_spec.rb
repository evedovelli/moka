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

  describe "image_url" do
    it "should return the complete image url" do
      expect(helper.image_url("logo_box.png")).to eql(URI.join("http://test.host", "assets/logo_box.png"))
    end
  end

  describe "canonical_url" do
    it "should return the canonial url" do
      @locale = "pt-BR"
      expect(helper.canonical_url("/pt-BR/battles/23")).to eql(URI.join("https://batalharia.com", "/battles/23"))
    end
  end
end
