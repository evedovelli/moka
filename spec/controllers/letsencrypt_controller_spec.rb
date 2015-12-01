require 'rails_helper'

RSpec.describe LetsencryptController, :type => :controller do

  describe "GET #challenge_0" do
    it "responds to text requests" do
      get :challenge_0, :format => 'text'
      expect(response.content_type).to eq(Mime::TEXT)
    end
    it "returns the required hash" do
      get :challenge_0, :format => 'text'
      expect(response.body).to eq('LZo2V6ot7n7FVSE1zxyOlntTalOlcCiXANi9AY71jVY.QGQUSxfEkcGfcMrZnOA8Ih7FQKuYkhiexBSTjJNWKSc')
    end
  end

end
