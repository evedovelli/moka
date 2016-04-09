class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if not validate_omniauth_data(request.env["omniauth.auth"], :facebook)
      respond_to do |format|
        format.js { render "users/facebook_share_error" }
        format.html { redirect_to new_user_registration_url }
      end
      return
    end

    #####################################################
    # PREPARE TO SHARE BATTLE
    #####################################################

    if request.env["omniauth.params"] &&
       request.env["omniauth.params"]["source"] &&
       request.env["omniauth.params"]["source"] == "share" &&
       request.env["omniauth.params"]["battle_id"]
      share_battle_on_facebook(request.env["omniauth.auth"].credentials, request.env["omniauth.params"]["battle_id"])
      redirect_to battle_path(request.env["omniauth.params"]["battle_id"])
      return
    end


    #####################################################
    # SIGN IN
    #####################################################

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
      else
        flash[:notice] = I18n.t('devise.registrations.signed_up_but_unconfirmed')
      end

      if request.env["HTTP_REFERER"]
        redirect_to :back
      else
        redirect_to root_path
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: :Facebook, reason: I18n.t('messages.omniauth_error')) if is_navigational_format?
      redirect_to new_user_registration_url
    end
  end

  def share_battle
    if params[:provider] == "facebook"
      flash[:scope] = 'public_profile,user_friends,email,publish_actions'
      flash[:display] = 'popup'
      redirect_to "/users/auth/facebook?source=share&battle_id=#{params[:battle_id]}"
    else
      flash[:alert] = I18n.t('messages.error_share', provider: params[:provider])
      redirect_to root_path
    end
  end

  def setup
    request.env['omniauth.strategy'].options['scope'] = flash[:scope] || request.env['omniauth.strategy'].options['scope']
    request.env['omniauth.strategy'].options['display'] = flash[:display] || request.env['omniauth.strategy'].options['display']
    render :text => "Setup complete.", :status => 404
  end

private
  def validate_omniauth_data(auth, provider)
    if (not auth) ||
       (not auth.info) ||
       (not auth.uid) ||
       (not auth.provider) ||
       (auth.provider.to_sym != provider) ||
       (not auth.credentials)
      set_flash_message(:alert, :failure, kind: provider, reason: I18n.t('messages.omniauth_unknown_error')) if is_navigational_format?
      return false
    end
    return true
  end

  def share_battle_on_facebook(credentials, battle_id)
    authorize! :share, Battle.find_by_id(battle_id)
    facebook_scrape(battle_url(battle_id), credentials.token)
    @graph = Koala::Facebook::API.new(credentials.token)
    @graph.put_connections("me", "batalharia:create", battle: battle_url(battle_id))
  end

  def facebook_scrape(url, access_token)
    uri = URI('https://graph.facebook.com')
    puts Net::HTTP.post_form(
        uri,
        'id' => "#{url}",
        'scrape' => 'true',
        'access_token' => "#{access_token}",
        'max' => '500')
  end
end
