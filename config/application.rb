require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Infocity
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #
    # config.action_cable.allowed_request_origins = [ 'localhost' ]
    # config.action_cable.allowed_request_origins = ['127.0.0.1'] # ENV['MY_IP'] # ['0.0.0.0', '127.0.0.1']
    Rails.application.config.action_cable.disable_request_forgery_protection = true
  end
end
