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
        sign_in(@user, event: :authentication)
        set_flash_message(:notice, :success, kind: :Facebook) if is_navigational_format?
        redirect_to :back
      else
        flash[:notice] = I18n.t('devise.registrations.signed_up_but_unconfirmed')
        redirect_to :back
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: :Facebook, reason: I18n.t('messages.omniauth_error')) if is_navigational_format?
      redirect_to new_user_registration_url
    end
  end

  def post_callback
    flash[:notice] = "Post callback correctly called with id #{session[:battle_id]}"
    redirect_to edit_user_registration_path
  end

  def post_battle
    scope = nil

    if params[:provider] == "facebook"
      flash[:scope] = 'public_profile,user_friends,email,publish_actions'
      flash[:callback_path] = '/users/auth/facebook/post_callback'
      flash[:display] = 'popup'
    end

    session[:battle_id] = params[:id]
    redirect_to "/users/auth/facebook"
  end

  def setup
    request.env['omniauth.strategy'].options['scope'] = flash[:scope] || request.env['omniauth.strategy'].options['scope']
    request.env['omniauth.strategy'].options['callback_path'] = flash[:callback_path] || request.env['omniauth.strategy'].options['callback_path']
    request.env['omniauth.strategy'].options['popup'] = flash[:popup] || request.env['omniauth.strategy'].options['popup']
    render :text => "Setup complete.", :status => 404
  end
end
