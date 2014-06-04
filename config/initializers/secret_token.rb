# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Scheduler::Application.config.secret_key_base = 'f55b4aaa9388efd58a17e7640068c30112842a1a495f7e8d87cb62f06f125cf8472e3f483db1b84235ca9ea0e25c4f775cc3e0cfb219a369de64129c03a86d5e'
