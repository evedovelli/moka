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
    # SHARE BATTLE
    #####################################################

    if request.env["omniauth.params"] &&
       request.env["omniauth.params"]["source"] &&
       request.env["omniauth.params"]["source"] == "share" &&
       request.env["omniauth.params"]["battle_id"]
      share_battle_on_facebook(request.env["omniauth.auth"].uid, request.env["omniauth.params"]["battle_id"])
      redirect_to battle_path(request.env["omniauth.params"]["battle_id"])
      return
    elsif request.env["omniauth.params"] &&
       request.env["omniauth.params"]["source"] &&
       request.env["omniauth.params"]["source"] == "share"
      flash[:alert] = I18n.t('messages.error_share', provider: "Facebook")
      redirect_to root_path
      return
    end


    #####################################################
    # FIND FACEBOOK FRIENDS
    #####################################################

    if request.env["omniauth.params"] &&
       request.env["omniauth.params"]["source"] &&
       request.env["omniauth.params"]["source"] == "find_friends" &&
       request.env["omniauth.auth"].credentials &&
       current_user
      friends = current_user.find_friends_from_facebook(request.env["omniauth.auth"].credentials)
      update_friends_list(current_user, friends)
      redirect_to user_facebook_friends_path
      return
    elsif request.env["omniauth.params"] &&
       request.env["omniauth.params"]["source"] &&
       request.env["omniauth.params"]["source"] == "find_friends" &&
       request.env["omniauth.auth"].credentials
      flash[:alert] = I18n.t('messages.error_find_friends_not_logged', provider: "Facebook")
      redirect_to root_path
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
      # Error: User already exists
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: :Facebook, reason: I18n.t('messages.omniauth_already_exists_error')) if is_navigational_format?
      redirect_to root_path

    elsif @user.persisted?
      # Success: User created successfully
      if @user.confirmed?
        sign_in(@user, event: :authentication)
        set_flash_message(:notice, :success, kind: :Facebook) if is_navigational_format?
      else
        flash[:notice] = I18n.t('devise.registrations.signed_up_but_unconfirmed')
      end

      redirect_to request.env['omniauth.origin'] || stored_location_for(resource) || root_path

    else
      # Error: Could not persist user
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      set_flash_message(:alert, :failure, kind: :Facebook, reason: I18n.t('messages.omniauth_error')) if is_navigational_format?
      redirect_to new_user_registration_url

    end
  end

  def share_battle
    authorize! :share, Battle.find_by_id(params[:battle_id])

    if params[:provider] == "facebook"
      flash[:scope] = 'public_profile,user_friends,email,publish_actions'
      flash[:display] = 'popup'
      redirect_to "/users/auth/facebook?source=share&battle_id=#{params[:battle_id]}"
    else
      flash[:alert] = I18n.t('messages.error_share', provider: params[:provider])
      redirect_to root_path
    end
  end

  def find_friends
    authorize! :find_friends, User

    if params[:provider] == "facebook"
      flash[:scope] = 'public_profile,user_friends,email'
      flash[:display] = 'popup'
      redirect_to "/users/auth/facebook?source=find_friends"
    else
      flash[:alert] = I18n.t('messages.error_find_friends', provider: params[:provider])
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

  def share_battle_on_facebook(uid, battle_id)
    authorize! :share, Battle.find_by_id(battle_id)

    params = {
      :client_id => ENV['FACEBOOK_KEY'],
      :client_secret => ENV['FACEBOOK_SECRET'],
      :grant_type => "client_credentials"
    }
    uri = URI("https://graph.facebook.com/oauth/access_token?#{params.to_query}")
    response = Net::HTTP.get(uri)
    access_token = Rack::Utils.parse_nested_query(response)["access_token"]
    unless access_token.nil?
      uri = URI('https://graph.facebook.com')
      Net::HTTP.post_form(uri,
                          'id' => canonical_battle_url(battle_id),
                          'scrape' => 'true',
                          'access_token' => "#{access_token}",
                          'max' => '500')

      @graph = Koala::Facebook::API.new(access_token)
      @graph.put_connections(uid, "batalharia:create", battle: canonical_battle_url(battle_id))
    end
  end

  def update_friends_list(user, friends)
    friends.each do |friend|
      user.update_facebook_friend(friend)
    end
  end

  def canonical_battle_url(battle_id)
    return "https://batalharia.com#{battle_path(battle_id).sub("\/#{@locale}", "")}"
  end

end
