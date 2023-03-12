# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bcrypt'
gem 'bootstrap-sass'
gem 'bootstrap-will_paginate' # この行を追加してください。
gem 'coffee-rails', '~> 4.2'
gem 'faker'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.6'
gem 'rails-i18n'
gem 'roo'
gem 'rubocop-rails', require: false
gem 'sass-rails',   '~> 5.0'
gem 'turbolinks',   '~> 5'
gem 'uglifier',     '>= 1.3.0'
gem 'will_paginate' # この行を追加してください。

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'sqlite3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :production do
  gem 'pg', '0.20.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
