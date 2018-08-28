class ValidateNewTransaction
	def initialize(amount:, transaction_type:, receiver_wallet_id:)
		@amount = amount
		@transaction_type = transaction_type
		@receiver_wallet_id = receiver_wallet_id
		@receiver_wallet = Wallet.where(id: @receiver_wallet_id).first
		@errors = []
	end

	def execute!
		validate_existance_of_wallet!
		if (@transaction_type == "withdraw" || @transaction_type == "transfer") && @receiver_wallet.present?
			validate_withdrawal! 
		end
		@errors
	end

	private
		def validate_existance_of_wallet!
			@errors << "Wallet not found" if @receiver_wallet.blank?
		end

		def validate_withdrawal!
			@errors << "Insufficient wallet balance" if @receiver_wallet.INR - @amount < 0
		end

end