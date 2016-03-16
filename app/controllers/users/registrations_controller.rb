class Users::RegistrationsController < Devise::RegistrationsController

  # Overwrite update_resource to let users to update their user without giving their password
  def update_resource(user, params)
    if user.identities.count > 0
      params.delete("current_password")
      user.update_without_password(params)
    else
      user.update_with_password(params)
    end
  end

  def create
    super do |user|
      user.email_settings = EmailSettings.create(user_id: user.id)
    end
  end
end
