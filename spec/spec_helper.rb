# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

require 'strings'

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers

  config.fixture_path = "#{::Rails.root}/spec/fixtures"


  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods
  config.include Strings
end

RSpec::Matchers.define :be_capitalized do
  match do |actual|
    actual.capitalize == actual
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new app, js_errors: false,
    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']
end

Capybara.configure do |config|
  config.default_selector  = :css
  config.javascript_driver = :poltergeist
  Capybara.default_wait_time = 10
end
