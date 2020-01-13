# Getting Started

## From Cloning to Testing

First, clone the git repository from Github and go to the new directory:


```
#!bash

git clone https://github.com/evedovelli/moka.git
cd moka
```

Then install necessary gems for running the project:

```
#!bash

bundle install
```

Paperclip gem assumes you have ImageMagick installed. You can find it at [www.imagemagick.org](www.imagemagick.org).


Move the database example in right place (it is not committed because it contains important private keys):

```
#!bash

cp database.yml.example database.yml
```

Migrate the version of your local database to the newest version from the cloned repository:

```
#!bash

rake db:migrate
```

In case the rake version you are using does not match the expected one, as listed in the Gemfile, prepending `bundle exec` to the command may be enough for successfully running it:

```
#!bash

bundle exec rake db:migrate
```

At last, check everything is running. Launch the rails server by executing `rails server` and visit the address [http://localhost:3000](http://localhost:3000) in your favorite browser. You are ready for developing and testing the application.


For Windows users, if you have installed rails in one drive and your repository is cloned to another drive, we may experience some trouble when running `rails server` one the gem `bootstrap-sass` is installed. This is due to [this](https://github.com/rails/rails/issues/660) issue in Rails 3. The workaround is to create a symbolic link to point a directory in the rails drive to the repository directory. For example:

```
#!bash
C:
mklink /D "C:/cappuccino/" "E:/projects/cappuccino/"
```
And then you may launch `rails server`, `cucumber` and `rspec` from the symbolic link directory in the drive that contains rails installed:
```
#!bash
cd C:/cappuccino/
rails server
```


## Turn a user into Administrator

Once the user is already created, from the command line, run `rails console` and then execute (replacing the user email):

```
#!ruby
user = User.find_by_email("admin@admin.com")
user.add_role(:admin)
```


# Autotests

## Before Testing

Rake Tasks for Preparing your Application for Testing

| Tasks | Description |
| ----- | ----------- |
| `rake db:test:clone` | Recreate the test database from the current environment's database schema |
| `rake db:test:clone_structure` | Recreate the test database from the development structure |
| `rake db:test:load` | Recreate the test database from the current schema.rb |
| `rake db:test:prepare` | Check for pending migrations and load the test schema |
| `rake db:test:purge` | Empty the test database. |

You can see all these rake tasks and their descriptions by running `rake --tasks --describe`


Usually you will just use the command `rake db:test:load`


## Behavior Tests

Behavior Tests will test the features, as described by a client.

We use cucumber for running behavior tests.

Tests are placed in the directory **features** and inside subdirectories corresponding to the models where they fit the best.

To run all behavior tests, in the base directory, execute:

```
#!bash

cucumber
```


To run tests from a specific file, execute:

```
#!bash

cucumber path/to/the/file
```


To run a specific test, execute:

```
#!bash

cucumber path/to/the/file:line_number
```


### Debugging in Cucumber

When using **selenium** (the tag `@javascript` is placed over the **scenario**), it is possible to print the browser screen with the command:


```
#!ruby

page.driver.browser.save_screenshot('/path/to/file/screenshot.png')
```

To print all the page body HTML, use the command:


```
#!ruby

puts page.body
```


## Unit Tests

Unit Tests will test the each unit of the code and warranty it works as expected.

We use **rspec** for running unit tests.

Tests are placed in the directory **spec** and inside subdirectories for models and controllers.

Each code written/modified in controllers and models must include its respective unit test to be integrated.

To run all unit tests, in the base directory, execute:

```
#!bash

rspec
```


To run tests from a specific file, execute:

```
#!bash

rspec path/to/the/file
```


To run a specific test, execute:

```
#!bash

rspec path/to/the/file:line_number
```


## Coverage

Coverage results are generated automatically with test executions.

The coverage results are kept in the directory coverage, and can be viewed in a browser by opening the file *cappuccino/coverage/index.html*.

Coverage results are expected to be 100% for Rspec tests and above 90% for features (cucumber).


# Developing

## Development Steps

1. Choose a feature from Backlog in [TBD](https://github.com/evedovelli/moka). Prioritize features with greater value;
2. If the feature is not updated with user stories, create them;
3. Add user stories to cucumber test files under `feature` directory;
4. Execute tests and watch them fail. It's time to hack to make them green;
5. [Generate model](http://guides.rubyonrails.org/getting_started.html#creating-the-article-model) if necessary, or update an existing model;
6. [Generate migrations](http://guides.rubyonrails.org/active_record_migrations.html) if necessary;
7. Add/update unit tests for models under `spec/models`;
8. [Generate controller](http://guides.rubyonrails.org/getting_started.html#saving-data-in-the-controller) or update it as necessary;
9. Add/update unit tests for controllers under `spec/controllers`;
10. Update views (this project uses Twitter Bootstrap and Simple Forms among other front end gems);
11. Add/update unit tests for view helpers if necessary under `spec/helpers`;
12. Write missing steps for cucumber behavior tests and see all go green;
13. Push to github and make a [pull request](https://github.com/evedovelli/moka/pull/new/master).


## Routes

Routes are configured in file *cappuccino/config/routes.rb*. All the configured routes can be seen with the command:

```
#!shell

rake routes
```

# Deploying

TODO
