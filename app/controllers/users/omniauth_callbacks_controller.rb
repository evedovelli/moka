class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if (not request.env["omniauth.auth"]) ||
       (not request.env["omniauth.auth"].info) ||
       (not request.env["omniauth.auth"].uid) ||
       (not request.env["omniauth.auth"].provider) ||
       (request.env["omniauth.auth"].provider.to_sym != :facebook)
      set_flash_message(:alert, :failure, kind: :Facebook, reason: I18n.t('messages.omniauth_unknown_error')) if is_navigational_format?
      redirect_to new_user_registration_url
      return
    end

    # Email is required. Ask again if it is not provided
    if (not request.env["omniauth.auth"].info.email) || (request.env["omniauth.auth"].info.email.blank?)
      redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
      return
    end

    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)

    if @user.nil?
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: :Facebook, reason: I18n.t('messages.omniauth_already_exists_error')) if is_navigational_format?
      redirect_to root_path
    elsif @user.persisted?
      if @user.confirmed?
        sign_in_and_redirect(@user, event: :authentication)
        set_flash_message(:notice, :success, kind: :Facebook) if is_navigational_format?
      else
        redirect_to :back
        flash[:notice] = I18n.t('devise.registrations.signed_up_but_unconfirmed')
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: :Facebook, reason: I18n.t('messages.omniauth_error')) if is_navigational_format?
      redirect_to new_user_registration_url
    end
  end
end
