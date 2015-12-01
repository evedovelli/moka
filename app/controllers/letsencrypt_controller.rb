class LetsencryptController < ApplicationController
  def challenge
    render text: "#{params[:id]}.QGQUSxfEkcGfcMrZnOA8Ih7FQKuYkhiexBSTjJNWKSc", layout: false, content_type: 'text/plain'
  end
end
