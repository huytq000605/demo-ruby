require 'microsoft_graph_auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/api/v1/integrations'
  end

  provider :outlook,
           ENV['AZURE_APP_ID'],
           ENV['AZURE_APP_SECRET'],
           scope: ENV['AZURE_SCOPES'],
           callback_path: '/api/v1/integrations/microsoft_oauth_callback'
end

OmniAuth.config.allowed_request_methods = %i[get]