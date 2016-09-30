Moka::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Path to imageMagick, used by PaperClip
  Paperclip.options[:command_path] = "/usr/bin/convert"

  # Mailer for Devise Authentication
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_mailer.delivery_method = :letter_opener

  # Test mode for OmniAuth
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '1234567',
    :info => {
      :email => 'joe@bloggs.com',
      :name => 'Joe Bloggs',
      :first_name => 'Joe',
      :last_name => 'Bloggs',
      :image => 'http://graph.facebook.com/1234567/picture?type=large',
      :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
      :location => 'Palo Alto, California',
      :verified => true
    },
    :credentials => {
      :token => 'ABCDEF', # OAuth 2.0 access_token, which you may wish to store
      :expires_at => 1321747205, # when the access token expires (it always will)
      :expires => true # this will always be true
    },
    :extra => {
      :raw_info => {
        :id => '1234567',
        :name => 'Joe Bloggs',
        :first_name => 'Joe',
        :last_name => 'Bloggs',
        :link => 'http://www.facebook.com/jbloggs',
        :username => 'jbloggs',
        :location => { :id => '123456789', :name => 'Palo Alto, California' },
        :gender => 'male',
        :email => 'joe@bloggs.com',
        :timezone => -8,
        :locale => 'en_US',
        :verified => true,
        :updated_time => '2011-11-11T06:21:03+0000'
      }
    }
  })
end
