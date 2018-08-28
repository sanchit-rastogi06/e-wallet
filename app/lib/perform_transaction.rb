class PerformTransaction
	def initialize(amount:, transaction_type:, receiver_wallet_id:, sender:)
		@amount = amount
		@transaction_type = transaction_type
		@receiver_wallet_id = receiver_wallet_id
		@receiver_wallet = Wallet.where(id: @receiver_wallet_id).first
		@sender_wallet = sender.wallet
	end

	def execute!
		ActiveRecord::Base.transaction do
			WalletTransaction.create!(receiver_wallet_id: @receiver_wallet_id, sender_wallet_id: @sender_wallet.id,
									amount: @amount, transaction_type: @transaction_type)

			if @transaction_type == "withdraw"
				@receiver_wallet.update!(INR: @receiver_wallet.INR - @amount)
			elsif @transaction_type == "deposit"
				@receiver_wallet.update!(INR: @receiver_wallet.INR + @amount)
			elsif @transaction_type == "transfer"
				@sender_wallet.update!(INR: @sender_wallet.INR - @amount)
				@receiver_wallet.update!(INR: @receiver_wallet.INR + @amount)
			end
		rescue ActiveRecord::StaleObjectError
			nil
		end
	end
end