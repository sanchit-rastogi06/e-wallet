class WalletsController < ApplicationController
	def new_transaction
		parameters = transaction_params
		receiver_wallet = ExecuteTransaction.new(amount: parameters[:amount], transaction_type: parameters[:transaction_type],
								receiver_wallet_id: parameters[:receiver_wallet_id], sender: @current_user).execute!
		render json: { sender: @current_user.id, receiver: receiver_wallet.user_id, amount: parameters[:amount] }, status: :ok
	end

	private

		def transaction_params
			{ amount: params.require(:amount),
			transaction_type: params.require(:transaction_type),
			receiver_wallet_id:	params.require(:receiver_wallet_id) }
		end

end






























