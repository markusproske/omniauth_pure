# Be sure to restart your server when you modify this file.

OmniauthDemo::Application.config.session_store :cookie_store

OmniauthDemo::Application.config.session = {
  :key          => '_omniauthpure_session',     # name of cookie that stores the data
  :domain       => nil,                         # you can share between subdomains here: '.communityguides.eu'
  :expire_after => 1.month,                     # expire cookie
  :secure       => false,                       # fore https if true
  :httponly     => true,                        # a measure against XSS attacks, prevent client side scripts from accessing the cookie
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# OmniauthDemo::Application.config.session_store :active_record_store
