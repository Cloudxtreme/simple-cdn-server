# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
SimpleCDNServer::Application.config.secret_key_base = 'f59aa79b6de7015d7e831f6928775fa3bfc826ad72e07757d0e90afa08c554d3fd45e57d4689b9d66b17a851b922d60ea39442ba7c18c23c413c564e5f58dd3c'
