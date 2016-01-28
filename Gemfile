source 'https://rubygems.org'

ruby '2.1.5'

gem 'rails', '3.2.17'

group :development do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0.2'

  # To intercept and open sent emails on browser
  gem 'letter_opener'
end
group :development, :test do
  gem 'sqlite3'

  # rspec will be used for unit tests
  gem "rspec-rails", ">= 2.12.2"

  # For easing the creation of instances of models
  gem "factory_girl_rails", ">= 4.2.0"

  # Used to drive browser in tests
  gem "selenium-webdriver", "~> 2.46.0"
end
group :test do
  gem "database_cleaner", ">= 0.9.1"

  # To test mailers
  gem "email_spec", ">= 1.4.0"

  # cucumber will be used for behavior tests
  gem "cucumber-rails", ">= 1.4.2", :require => false

  gem "launchy", ">= 2.1.2"
  gem "capybara", ">= 2.2.1"

  # For analysis of code coverage in tests
  gem 'simplecov', '~> 0.9', :require => false

  # For time traveling :)
  gem "timecop", "~> 0.7.1"

  gem 'i18n-tasks', '~> 0.7.3'

  # Mocks web requests for tests
  gem 'webmock', '~> 1.22'
end
group :production do
  gem 'pg'
  gem 'rails_12factor'
end

# Use Puma as the app server
gem 'puma', ">= 2.14.0"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-script-source', '1.8.0'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'sass', '3.2.8'

# Using Twitter bootstrap for given a nice look
# to the website easily, and the most important,
# for creating a responsive website that adapts
# according to the size of the screen, improving
# the user experience.
gem 'bootstrap-sass', '2.3.2.0'

gem 'jquery-rails'

# Turbolinks speed up navigation, making every
# requisition an ajax requisition, so the assets
# are not reloaded. It updates the URL, so the
# application keeps RESTfull.
gem 'turbolinks'

# To create nested forms on the fly
gem 'nested_form', '~> 0.3.2'

# Binds Rails Turbolinks events to the document.ready events
gem 'jquery-turbolinks'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# To use debugger
# gem 'debugger'

# For attaching images
gem "paperclip", "~> 3.5.3"

# To use Paperclip with AWS S3
gem 'aws-sdk', '~> 1.6'


# For allowing file uploads using Ajax
gem 'remotipart', '~> 1.2'

# For user authentication
gem "devise", ">= 3.2.4"

# Sign up with Facebook account
gem 'omniauth-facebook'

# Used to set roles for user
gem 'rolify'

# For handling permissions according to user's roles
gem 'cancancan', '~> 1.10'

# Used to add the location to URL (optional)
gem 'routing-filter'

# Simplify writing forms and handling their errors
gem 'simple_form'

# To validate forms in client side
gem "jquery-validation-rails"

# To show progress while charging pages
gem 'nprogress-rails'

# To paginate index pages
gem 'kaminari', '~> 0.16.3'

# To create tags based on hashtags
gem 'acts-as-taggable-on', '~> 3.4.2'

# To filter hashtags into sentences
gem 'twitter-text', '~> 1.13.0'
