class FriendshipMailer < ApplicationMailer
  add_template_helper(UsersHelper)

  def new_follower(follower, following)
    @follower = follower
    @user = following
    attachments.inline['logo_short.png'] = {
      content_type: 'image/png',
      content: File.open(Rails.root.join('app', 'assets', 'images', 'logo_short.png'), 'rb'){|f| f.read}
    }
    mail(from: I18n.t('mailers.friendship.from', locale: (@user.language || I18n.locale)),
         to: @user.email,
         subject: I18n.t('mailers.friendship.new', follower: user_name_for(@follower), locale: (@user.language || I18n.locale)))
  end

  def facebook_friend_sign_up(friend, user)
    @friend = friend
    @user = user
    attachments.inline['logo_short.png'] = {
      content_type: 'image/png',
      content: File.open(Rails.root.join('app', 'assets', 'images', 'logo_short.png'), 'rb'){|f| f.read}
    }
    mail(from: I18n.t('mailers.friendship.from', locale: (@user.language || I18n.locale)),
         to: @user.email,
         subject: I18n.t('mailers.friendship.facebook_friend', friend: user_name_for(@friend), locale: (@user.language || I18n.locale)))
  end

private

  def user_name_for(user)
    return user.name || user.username
  end

end
