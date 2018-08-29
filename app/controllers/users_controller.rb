class UsersController < ApplicationController
	skip_before_action :authenticate_request!, only: [:create]

	def create
		user = User.new(user_params)
		user.auth_token = unique_auth_token
		uri = ROTP::TOTP.new(user.auth_token, issuer: "Koinex").provisioning_uri(user.email)
		if user.save
			render json: { message: 'User created successfully', provisioning_uri: uri}, status: :created
		else
			raise CustomError.new "Request Failed"
		end
	end

	private

		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end

		def unique_auth_token
			loop do
				auth_token = ROTP::Base32.random_base32
				return auth_token if !User.exists?(auth_token: auth_token)
			end
		end

end
