class AuthenticationController < ApplicationController

	skip_before_action :authenticate_request!, only: [:create]

	def show
		user = User.find_by(id: params[:id])
		if !user.nil?
			render json: { email: user.email, balance: Wallet.where(user_id: user.id).first.INR }, status: :ok
		else
			render json: { error: 'Invalid request' }, status: :bad_request
		end
	end

	def create
		user = User.find_by(email: user_params[:email])
		if user && user.authenticate(user_params[:password]) && two_factor_auth(user.auth_token)
			jwt = JsonWebToken.encode({ user_id: user.id })
			render json: { jwt: jwt }, status: :ok
		else
			render json: { error: 'Invalid email/password/otp' }, status: :unauthorized
		end
	end

	private

		def user_params
			params.require(:user).permit(:email, :password)
		end

		def otp_param
			params.require(:otp)
		end

		def two_factor_auth(auth_token)
			otp = ROTP::TOTP.new(auth_token)
			otp.verify(otp_param)
		end
end
