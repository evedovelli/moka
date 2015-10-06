module NotificationsHelper
  def notifications_btn(user)
    if !user || user.unread_notifications == 0
      return '<div id="notifications-none"></div>'.html_safe
    else
      return "<div id=\"notifications-unread\"><p class=\"notifications-btn-text center\">#{user.unread_notifications}</p></div>".html_safe
    end
  end
end

