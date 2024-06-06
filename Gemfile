source 'https://rubygems.org'

###### BASIC FRAMEWORKS ######
ruby '3.1.4'
# Rails web framework
gem 'rails', '~> 7.1.3', '>= 7.1.3.3'
# Postgres database adapter
gem 'pg', '~> 1.1'
# Web server
gem 'puma', '>= 5.0'
# Use Redis adapter for Action Cable
gem 'redis', '>= 4.0.1'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
# Use Active Storage variants
gem 'image_processing', '~> 1.2'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors'

##### ADDITIONAL FUNCTIONS #####
# Environment variable and configuration management
gem 'dotenv-rails', '~> 3.1'

# User management and login workflow
gem 'devise', '>= 4.7.1'

# Version API management
gem 'versionist', '~> 2.0', '>= 2.0.1'

# Serializer for JSON output
gem 'fast_jsonapi', '~> 1.5'

# For pagination
gem 'pagy', '~> 8.4'

# For internationalize locale
gem 'rails-i18n', '~> 7.0', '>= 7.0.9'

group :development, :test do
  gem 'debug', platforms: %i[mri windows]

  # Generate models based on factory definitions
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  # Ensure the database is in a clean state on every test
  gem 'database_cleaner-active_record', '~> 2.1'
  # Generate fake data for use in tests.
  gem 'faker', '~> 3.3', '>= 3.3.1'
  # RSpec behavioral testing framework for Rails
  gem 'rspec-rails', '~> 6.1.2'
end

group :development do
  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]

  # Show database columns and indexes inside files
  gem 'annotate', '~> 3.2'
  # Command line tool for better object printing
  gem 'awesome_print', '~> 1.9', '>= 1.9.2'
  # Static analysis / linter.
  gem 'rubocop'
  # Rails add-on for static analysis
  gem 'rubocop-performance'
  gem 'rubocop-rails', '~> 2.25.0'
  # Default rules for Rubocop
  gem 'standard', '~> 1.36'
end

group :test do
  # More concise test ("should") matchers
  gem 'shoulda-matchers', '~> 6.2'

  # For code coverage analysis
  gem 'simplecov', '~> 0.22.0'
end
