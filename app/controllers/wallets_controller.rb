class WalletsController < ApplicationController
	def new_transaction
		amount = params.require(:amount)
		transaction_type = params.require(:transaction_type)
		receiver_wallet_id = params.require(:receiver_wallet_id)
		receiver_wallet = Wallet.where(id: receiver_wallet_id).first

		errors = ValidateNewTransaction.new(amount: amount, transaction_type: transaction_type, 
										receiver_wallet_id: receiver_wallet_id).execute!
		
		if transaction_conditions?(transaction_type, receiver_wallet_id)
			if errors.size == 0
				if PerformTransaction.new(amount: amount, transaction_type: transaction_type,
											 receiver_wallet_id: receiver_wallet_id, sender: @current_user).execute!
					render json: { sender: @current_user.id, receiver: receiver_wallet.user_id, amount: amount }, status: :ok
				else
					render json: { errors: "Stale object" }, status: :bas_request
				end
			else
				render json: { errors: errors }, status: 402
			end	
		else
			render json: { error: "Unauthorized" }, status: :unauthorized
		end

	end

	private
		def user_authorized?(type, id)
			if @current_user.id != Wallet.find(id).user_id
				false
			else
				true
			end	
		end

		def transaction_conditions?(type, id)
			type == "transfer" || ( (type == "deposit" || type == "withdraw") && user_authorized?(type, id) )
		end
end
