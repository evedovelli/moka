class EmailSettingsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :user, :find_by => :username
  load_and_authorize_resource :email_settings, :through => :user, :singleton => true

  def edit
  end

  def update
    if not @email_settings.update_attributes(params[:email_settings])
      render 'edit'
      return
    end
    flash[:notice] = I18n.t('messages.email_settings_successfully_updated')
    redirect_to user_path(@user)
  end
end
