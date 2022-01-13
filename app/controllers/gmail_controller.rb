require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

CREDENTIALS_PATH = "#{Rails.root}/app/controllers/credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
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
  Gmail = Google::Apis::GmailV1

  def index
    credentials = authorize(params[:abc])
    if credentials.nil?
      return
    end
    gmail = Gmail::GmailService.new
    gmail.authorization = credentials

    message = RMail::Message.new
    message.header['To'] = 'huy.tranquang@employmenthero.com'
    message.header['From'] = 'huy.tranquang123@employmenthero.com'
    message.header['Subject'] = 'Test send email'
    message.header['Test_Header'] = 'This is my header'
    message.body = 'Test'
    gmail.send_user_message('me', upload_source: StringIO.new(message.to_s), content_type: 'message/rfc822')
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

  def get_email
    debugger
    credentials = authorize(params['abc'])
    return if credentials.nil?

    gmail = Gmail::GmailService.new
    gmail.authorization = credentials
    emails = gmail.list_user_messages('me', include_spam_trash: false)
    emails
  end

  def authorize(old_url)
    job = params[:job]
    client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
    token_store = TokenStore.new
    authorizer = Google::Auth::WebUserAuthorizer.new client_id, SCOPE, token_store, 'http://localhost:3000/test'
    credentials = authorizer.get_credentials job
    if credentials.nil?
      url = authorizer.get_authorization_url redirect_to: old_url, state: {job: job}
      redirect_to url
      return nil
    end
    credentials
  end
end
