require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
CREDENTIALS_PATH = "#{Rails.root}/app/controllers/credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_READONLY
REDIRECT = 'http://localhost:3000/test'

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials

class TokenStore < Google::Auth::TokenStore 
  def load(id)
    ::JobToken.find_by(job_id: id)&.token
  end

  def store(id, token)
    auth = ::JobToken.create_or_find_by(job_id: id)
    auth.update(token: token)
  end

  def delete(id)
    ::JobToken.destroy_by(job_id: id)
  end
end

class GmailController < ApplicationController
  def index
    return authorize(params[:abc])
  end

  def test
    state = JSON.parse(params['state'], object_class: OpenStruct)
    job = state.job
		client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
		token_store = TokenStore.new
    credentials, target_url = Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, 'http://localhost:3000/test').handle_auth_callback(
      job,
      request)
    redirect_to target_url
  end

  def authorize(old_url)
    job = params[:job]
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = TokenStore.new
    authorizer = Google::Auth::WebUserAuthorizer.new client_id, SCOPE, token_store, 'http://localhost:3000/test'
    credentials = authorizer.get_credentials job, request
    if credentials.nil?
      url = authorizer.get_authorization_url request: request, redirect_to: old_url, state: {job: job}
      redirect_to url
    end
    credentials
  end

  # Initialize the API
  def init_svc
    service = Google::Apis::GmailV1::GmailService.new
    service.client_options.application_name = 'ATS'
    service.authorization = authorize

    # Show the user's labels
    user_id = 'me'
    result = service.list_user_labels user_id
    puts 'Labels:'
    puts 'No labels found' if result.labels.empty?
    result.labels.each { |label| puts "- #{label.name}" }
  end
end
