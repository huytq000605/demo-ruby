class ApplicationController < ActionController::Base
	include Pundit
	skip_before_action :verify_authenticity_token
	before_action :set_default_response_format


	rescue_from ActiveRecord::RecordInvalid, with: :show_errors
	rescue_from ActiveRecord::RecordNotFound, with: :not_found
	rescue_from Pundit::NotAuthorizedError, with: :show_errors

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
end
