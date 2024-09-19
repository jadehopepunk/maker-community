source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.3'

gem 'rails', '~> 7.2'

gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'pg'
gem 'puma', '~> 6.4.2'
gem 'sprockets-rails'

gem 'aasm'
gem 'acts-as-taggable-on', '~> 11.0.0'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'devise'
gem 'hash_to_hidden_fields'
gem 'icalendar'
gem 'image_processing', '~> 1.2'
gem 'indefinite_article'
gem 'kaminari'
gem 'month'
gem 'pundit'
gem 'ransack', '~> 4.2.1'
gem 'redis'
gem 'rolify'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sidekiq'
gem 'simple_form'
gem 'slack-ruby-client'
gem 'stimulus-rails'
gem 'stripe'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Need while we integrate with Wordpress
gem 'down'
gem 'mysql2'
gem 'php-serialize'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'rubocop'
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'database_cleaner-active_record'
  gem 'rspec-rails'
end
