class ApplicationController < ActionController::Base
	include Pundit
	skip_before_action :verify_authenticity_token # csrf
	before_action :set_default_response_format
	before_action :authorized


	rescue_from ActiveRecord::RecordInvalid, with: :show_errors
	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	rescue_from Pundit::NotAuthorizedError, with: :show_errors
	rescue_from ActionController::ParameterMissing, with: :show_errors


	protected

	def set_default_response_format
		request.format = :json
	end

	def not_found(e)
		respond_to do |format|
			format.json { render json: {message: e}, status: 404 }
		end
	end

	def show_errors(e)
		respond_to do |format|
			format.json { render json: {message: e}, status: 422 }
		end
	end

	def invalid_argument(e)
		respond_to do |format|
			format.json { render json: {message: e}, status: 400}
		end
	end

	def current_user
		@current_user
	end

	def unauthorized
		render json:{message: "Unauthorized"}, status: 401
	end


	def authorized
		header = request.headers['Authorization']
		if header.nil? or not header.start_with? 'Bearer '
			unauthorized
			return
		end
		token = header[7..-1]
		payload = Auth::Jwt.decode(token)
		if payload.nil?
			unauthorized
			return
		end
		payload = payload[0]
		@current_user = {email: payload['email'], role: payload['role']}
	end

	def only_admin
		if current_user[:email] != 'admin'
			unauthorized
			return
		end
	end
end
