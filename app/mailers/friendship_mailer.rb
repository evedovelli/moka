class FriendshipMailer < ApplicationMailer
  add_template_helper(UsersHelper)

  def new_follower(follower, following)
    @follower = follower
    @user = following
    attachments.inline['logo_short.png'] = {
      content_type: 'image/png',
      content: File.open(Rails.root.join('app', 'assets', 'images', 'logo_short.png'), 'rb'){|f| f.read}
    }
    mail(from: I18n.t('mailers.friendship.from'),
         to: @user.email,
         subject: I18n.t('mailers.friendship.new', follower: @follower.username))
  end
end
