class WalletsController < ApplicationController
	def new_transaction
		amount = params.require(:amount)
		transaction_type = params.require(:transaction_type)
		receiver_wallet_id = params.require(:receiver_wallet_id)
		receiver_wallet = Wallet.find_by(id: receiver_wallet_id)

		errors = ValidateNewTransaction.new(amount: amount, transaction_type: transaction_type, 
										receiver_wallet: receiver_wallet).execute!

		if "Wallet not found".in?(errors)
			render json: { errors: "Wallet not found" }, status: 402

		elsif transaction_conditions?(transaction_type, receiver_wallet.user_id)
			if errors.blank?
				if PerformTransaction.new(amount: amount, transaction_type: transaction_type,
											 receiver_wallet: receiver_wallet, sender: @current_user).execute!
					render json: { sender: @current_user.id, receiver: receiver_wallet.user_id, amount: amount }, status: :ok
				else
					render json: { errors: "Stale object" }, status: :bad_request
				end
			else
				render json: { errors: errors }, status: 402
			end

		else
			render json: { error: "Unauthorized" }, status: :unauthorized
		end

	end

	private
		def user_authorized?(receiver_id)
			if @current_user.id != receiver_id
				false
			else
				true
			end	
		end

		def transaction_conditions?(type, receiver_id)
			type == "transfer" || ( (type == "deposit" || type == "withdraw") && user_authorized?(receiver_id) )
		end
end
