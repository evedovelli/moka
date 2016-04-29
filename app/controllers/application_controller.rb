class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  def default_url_options(options={})
    options.merge({
      locale: I18n.locale,
    })
  end

  def set_locale
    if not I18n.available_locales.map(&:to_s).include?(params[:locale])
      params[:locale] = nil
    end
    I18n.locale = params[:locale] || I18n.default_locale

    if current_user
      I18n.locale = current_user.language || I18n.locale
    end

    @locale = I18n.locale
  end

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = I18n.t('messages.access_denied')
    redirect_to root_url
  end

  rescue_from Paperclip::Errors::NotIdentifiedByImageMagickError do |exception|
    flash[:alert] = I18n.t('messages.invalid_image')
    redirect_to request.referer
  end

  rescue_from Faraday::ConnectionFailed do |exception|
    flash[:alert] = I18n.t('messages.facebook_share_timeout')
    redirect_to request.referer
  end

  rescue_from Faraday::TimeoutError do |exception|
    flash[:alert] = I18n.t('messages.facebook_share_timeout')
    redirect_to request.referer
  end

end
