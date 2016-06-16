module UsersHelper
  def user_button_for(user, btn_classes = "btn-large")
    if !current_user
      return (link_to(user_sign_in_popup_path, remote: true, :class => "btn #{btn_classes} btn-block btn-follow") do
               "<i class=\"icon-plus\"></i> #{I18n.t('users.show.follow')}".html_safe
             end).html_safe
    end

    if current_user == user
      return link_to(t('users.show.edit_account'), edit_user_registration_path, :class => "btn btn-info btn-block #{btn_classes} btn-edit-profile")
    else
      if current_user.is_friends_with?(user)
        friendship = current_user.get_friendship_with(user)
        return link_to(user_friendship_path(current_user, :id => friendship.id), method: :delete, remote: true, :class => "btn btn-success btn-unfollow #{btn_classes} btn-block") do
                 "<span class=\"following\"><i class=\"icon-ok icon-inverse\"></i> #{I18n.t('users.show.following')}</span>"\
                 "<span class=\"unfollow\"><i class=\"icon-remove icon-inverse\"></i> #{I18n.t('users.show.unfollow')}</span>".html_safe
               end
      else
        return (link_to(user_friendships_path(current_user, :friend_id => user.id), method: :post, remote: true, :class => "btn #{btn_classes} btn-block btn-follow") do
                 "<i class=\"icon-plus\"></i> #{I18n.t('users.show.follow')}".html_safe
               end).html_safe
      end
    end
  end

  def mini_user_button_for(user)
    if !current_user
      return (link_to(user_sign_in_popup_path, remote: true, :class => "btn btn-block btn-follow") do
               "<i class=\"icon-plus\"></i><i class=\"icon-user\"></i>".html_safe
             end).html_safe
    end

    if current_user == user
      return link_to(edit_user_registration_path, :class => "btn btn-info btn-block btn-edit-profile") do
               "<i class=\"icon-edit\"></i>".html_safe
             end
    else
      if current_user.is_friends_with?(user)
        friendship = current_user.get_friendship_with(user)
        return link_to(user_friendship_path(current_user, :id => friendship.id), method: :delete, remote: true, :class => "btn btn-success btn-unfollow btn-block") do
                 "<span class=\"following\"><i class=\"icon-ok icon-inverse\"></i><i class=\"icon-user icon-inverse\"></i></span>"\
                 "<span class=\"unfollow\"><i class=\"icon-remove icon-inverse\"></i><i class=\"icon-user icon-inverse\"></i></span>".html_safe
               end
      else
        return (link_to(user_friendships_path(current_user, :friend_id => user.id), method: :post, remote: true, :class => "btn btn-block btn-follow") do
                 "<i class=\"icon-plus\"></i><i class=\"icon-user\"></i>".html_safe
               end).html_safe
      end
    end
  end

  def user_name_for(user)
    return user.name || user.username
  end

  def from_omniauth?(user)
    return user && user.identities && user.identities.count > 0
  end

  def find_facebook_friends_button(message)
    if user_signed_in?
      return link_to('/users/auth/facebook/friends',
                 :id => 'facebook-friends-find',
                 :class => 'btn btn-primary btn-large btn-facebook btn-block') do
        "<table class=\"facebook-login-table\">"\
          "<tr>"\
            "<td>#{ fa_icon "facebook-square", class: "fa-2x" }</td>"\
            "<td></td>"\
            "<td>#{ message }</td>"\
          "</tr>"\
        "</table>".html_safe
      end
    else
      return ""
    end
  end
end
