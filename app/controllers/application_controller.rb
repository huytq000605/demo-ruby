class ApplicationController < ActionController::Base
	include Pundit
	skip_before_action :verify_authenticity_token
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

	def authorized
		header = request.headers['Authorization']
		if not header.start_with? 'Bearer '
			render json:{message: "Unauthorized"}, status: 401
			return
		end
		token = header[7..-1]
		payload = Auth::Jwt.decode(token)[0]
		if payload.nil?
			render json:{message: "Unauthorized"}, status: 401
			return
		end
		@current_user = {email: payload['email'], role: payload['role']}
	end
end
