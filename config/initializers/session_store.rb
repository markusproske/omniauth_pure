# Be sure to restart your server when you modify this file.

# OmniauthDemo::Application.config.session_store :active_record_store
OmniauthDemo::Application.config.session_store :cookie_store

OmniauthDemo::Application.config.session = {
  :key          => '_omniauthpure_session',     # name of cookie that stores the data
  :domain       => nil,                         # you can share between subdomains here: '.communityguides.eu'
  :expire_after => 1.month,                     # expire cookie
  :secure       => false,                       # fore https if true
  :httponly     => true,                        # a measure against XSS attacks, prevent client side scripts from accessing the cookie
  
  :secret      => 'cb8e1ac9dd5f4d08974f9f4d74abb45239a98b6cc3c59829ce6b61280160c421b4c18b0a721c26e0b4f43c119587590262f0341821bf31fa5bf426d65236a394'
}
