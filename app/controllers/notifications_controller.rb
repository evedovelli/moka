class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :notification

  def index
    @notifications = current_user.notifications.order(:created_at).reverse_order.page(params[:page])
    current_user.reset_unread_notifications
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def dropdown
    @notifications = current_user.notifications.order(:created_at).reverse_order.page(params[:page]).per(6)
    current_user.reset_unread_notifications
    respond_to do |format|
      format.js {}
    end
  end

end
