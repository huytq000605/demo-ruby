# Load the Rails application.
require_relative "application"

oauth_environment_variables = File.join(Rails.root, 'config', 'outlook_oauth.rb')
load(oauth_environment_variables) if File.exist?(oauth_environment_variables)

# Initialize the Rails application.
Rails.application.initialize!
