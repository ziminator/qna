source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 4.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'slim-rails'
gem 'devise'
gem 'bootstrap'
gem 'sassc-rails'
gem "twitter-bootstrap-rails"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "aws-sdk-s3", require: false
gem 'cocoon'
gem 'rubocop', require: false
gem 'validate_url'
gem 'octokit'
gem 'font-awesome-sass', '~> 5.15.1'
gem 'skim'
gem 'gon'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem 'omniauth-instagram'
gem 'cancancan'
gem 'pundit'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'whenever', require: false
gem 'mysql2'
gem 'thinking-sphinx'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'dotenv-rails'
  gem 'letter_opener'
  gem 'capybara-email'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  #Testing
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
