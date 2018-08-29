class ApplicationController < ActionController::API

	before_action :authenticate_request!

	protected

		def authenticate_request!
			if !payload || !JsonWebToken.valid_payload(payload.first.symbolize_keys)
				invalid_authentication
			else 
				load_current_user!
				if !@current_user
					invalid_authentication
				end
			end
		end

		def invalid_authentication
			raise "Authentication Failed"
			#return render json: { error: 'Authentication Failed' }, status: :unauthorized
		end

	private
		
		def payload
			auth_header = request.headers['AUTHORIZATION']
			token = auth_header.split(' ').last
			JsonWebToken.decode(token)
		rescue
			nil
		end

		def load_current_user!
			@current_user = User.find_by(id: payload.first['user_id']) 
		end

end
