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
