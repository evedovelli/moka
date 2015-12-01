class LetsencryptController < ApplicationController
  def challenge_0
    render text: "LZo2V6ot7n7FVSE1zxyOlntTalOlcCiXANi9AY71jVY.QGQUSxfEkcGfcMrZnOA8Ih7FQKuYkhiexBSTjJNWKSc", layout: false, content_type: 'text/plain'
  end
end
