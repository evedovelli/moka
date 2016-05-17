module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  # When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      root_path

    when /my home\s?page/
      root_path

    when /my (?:|user )profile page/
      user_path("myself")

    when /the "([^"]*)" profile page/
      user_path($1)

    when /the sign up page/
      new_user_registration_path

    when /the sign in page/
      new_user_session_path

    when /the edit account page/
      edit_user_registration_path

    when /the edit profile picture page for "([^"]*)"/
      edit_user_path($1)

    when /the social settings page/
      user_social_path

    when /the option index page/
      options_path

    when /my following page/
      user_following_path("myself")

    when /my followers page/
      user_followers_path("myself")

    when /the "([^"]*)" following page/
      user_following_path($1)

    when /the "([^"]*)" followers page/
      user_followers_path($1)

    when /the user index page/
      users_path

    when /the (\d+)(?:st|nd|rd|th) battle page/
      battle_path($1)

    when /the "([^"]*)" battle page/
      battle_path(Battle.find_by_title($1))

    when /the (\d+)(?:st|nd|rd|th) battle edit page/
      edit_battle_path($1)

    when /my notifications' page/
      notifications_path

    when /the "([^"]*)" hashtag page/
      hashtag_path($1)

    when /the votes page for option "([^"]*)"/
      option_votes_path(Option.find_by_name($1))

    when /my email settings page/
      edit_user_email_settings_path("myself")

    when /the privacy policy page/
      page_path('privacy_policy')

    when /the terms of service page/
      page_path('terms_of_service')

    when /the find Facebook friends page/
      '/users/auth/facebook/friends'

    when /the Facebook friends page/
      user_facebook_friends_path

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

