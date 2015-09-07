# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Although this is not needed for an api-only application, rails4 
# requires secret_key_base or secret_token to be defined, otherwise an 
# error is raised.
# Using secret_token for rails3 compatibility. Change to secret_key_base
# to avoid deprecation warning.
# Can be safely removed in a rails3 api-only application.
Backtester::Application.config.secret_token = '8e5cb59fa629df3ebac7b3ac74b9d9aa423559eb9327d3d02b8f8d0b5319dace172857d08239bc3b5a143deaf31b7cb51209b72a15d842d1daf1a754723bf18a'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
