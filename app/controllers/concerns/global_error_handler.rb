module GlobalErrorHandler extend ActiveSupport::Concern
	included do
		rescue_from CustomError, with: :render_custom_error_response
		rescue_from CustomAuthError, with: :render_custom_auth_error_response
	end

	def render_custom_error_response(exception)
		render json: { error: exception.message }, status: :bad_request
	end

	def render_custom_auth_error_response(exception)
		render json: { error: exception.message }, status: :unauthorized
	end
end