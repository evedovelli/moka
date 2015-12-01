require 'rails_helper'

RSpec.describe LetsencryptController, :type => :controller do

  describe "challenge" do
    it "responds to text requests" do
      get :challenge, :format => 'text', :id => "test"
      expect(response.content_type).to eq(Mime::TEXT)
    end
    it "returns the required hash" do
      get :challenge, :format => 'text', :id => "test"
      expect(response.body).to eq('test.QGQUSxfEkcGfcMrZnOA8Ih7FQKuYkhiexBSTjJNWKSc')
    end
  end

end
