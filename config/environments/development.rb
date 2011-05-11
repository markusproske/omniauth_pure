OmniauthDemo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  Rails.application.config.middleware.use OmniAuth::Builder do
    # ALWAYS RESTART YOUR SERVER IF YOU MAKE CHANGES TO THESE SETTINGS!
    
    # you need a store for OpenID; (if you deploy on heroku you need Filesystem.new('./tmp') instead of Filesystem.new('/tmp'))
    require 'openid/store/filesystem'
    
    # load certificates
    require "openid/fetchers"
    OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"
    
    # providers with id/secret, you need to sign up for their services (see below) and enter the parameters here
    provider :facebook, 'APP_ID', 'APP_SECRET'
    provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
    provider :github, 'CLIENT ID', 'SECRET'
    
    # generic openid
    provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'
    
    # dedicated openid
    provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
    # provider :google_apps, OpenID::Store::Filesystem.new('./tmp'), :name => 'google_apps'
    # /auth/google_apps; you can bypass the prompt for the domain with /auth/google_apps?domain=somedomain.com
    
    provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'yahoo', :identifier => 'yahoo.com' 
    provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'aol', :identifier => 'openid.aol.com'
    provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'myopenid', :identifier => 'myopenid.com'
    
    # Sign-up urls for Facebook, Twitter, and Github
    # https://developers.facebook.com/setup
    # https://github.com/account/applications/new
    # https://developer.twitter.com/apps/new
 end
end

