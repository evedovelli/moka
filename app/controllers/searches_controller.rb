class SearchesController < ApplicationController
  def search
    if (params[:search]) && (params[:search] != "") && (params[:commit])
      case params[:commit]
        when "user"
          redirect_to users_path(search: params[:search])
        when "hashtag"
          redirect_to hashtag_path(hashtag: params[:search])
        else
          flash[:alert] = I18n.t('messages.invalid_search')
          redirect_to root_url
      end
    else
      flash[:alert] = I18n.t('messages.invalid_search')
      redirect_to root_url
    end
  end
end
