source "https://rubygems.org"

###### BASIC FRAMEWORKS ######
ruby "3.1.4"
# Rails web framework
gem "rails", "~> 7.1.3", ">= 7.1.3.3"
# Postgres database adapter
gem "pg", "~> 1.1"
# Web server
gem "puma", ">= 5.0"
# Use Redis adapter for Action Cable
gem "redis", ">= 4.0.1"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
# Use Active Storage variants
gem "image_processing", "~> 1.2"
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

##### ADDITIONAL FUNCTIONS #####
gem "dotenv-rails", "~> 3.1"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end
