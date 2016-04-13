require 'rails_helper'
require 'application_controller'

describe ApplicationController do
  controller do
    def create
      raise Paperclip::Errors::NotIdentifiedByImageMagickError
    end
    def new
      raise Faraday::ConnectionFailed, %{500 "Server error"}
    end
    def index
      raise Faraday::TimeoutError, %{407 "Proxy Authentication Required "}
    end
  end

  describe "handling invalid image uploaded exceptions" do
    before :each do
      @referer = root_url
      allow(request).to receive(:referer).and_return @referer
      get :create
    end
    it "should redirects to the referer page" do
      expect(response).to redirect_to @referer
    end
    it "should redirects to the home page" do
      flash[:alert].should == "Invalid image"
    end
  end

  describe "handling Faraday (Facebook connection through Koala) failure" do
    before :each do
      @referer = root_url
      allow(request).to receive(:referer).and_return @referer
      get :new
    end
    it "should redirects to the referer page" do
      expect(response).to redirect_to @referer
    end
    it "should redirects to the home page" do
      flash[:alert].should == "Failed to share image on Facebook. Please try again!"
    end
  end

  describe "handling Faraday (Facebook connection through Koala) timeout" do
    before :each do
      @referer = root_url
      allow(request).to receive(:referer).and_return @referer
      get :index
    end
    it "should redirects to the referer page" do
      expect(response).to redirect_to @referer
    end
    it "should redirects to the home page" do
      flash[:alert].should == "Failed to share image on Facebook. Please try again!"
    end
  end
end
