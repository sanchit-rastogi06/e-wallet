class ExecuteTransaction
	def initialize(amount:, transaction_type:, receiver_wallet_id:, sender:)
		@amount = amount
		@transaction_type = transaction_type
		@receiver_wallet_id = receiver_wallet_id
		@receiver_wallet = Wallet.find_by(id: @receiver_wallet_id)
		@sender = sender
		@sender_wallet = @sender.wallet
	end

	def execute!
		validate_transaction!
		perform_transaction!	
	end

	def validate_transaction!

		if @receiver_wallet.nil?
			raise CustomError.new "Wallet not found"
		end
		if (@transaction_type == "withdraw" || @transaction_type == "transfer") && @receiver_wallet.INR - @amount < 0 
			raise CustomError.new "Insufficient wallet balance"
		end
		if !user_authorized?(@transaction_type, @receiver_wallet.user_id)
			raise CustomAuthError.new "Unauthorized"
		end

	end

	def perform_transaction!
		ActiveRecord::Base.transaction do
			WalletTransaction.create!(receiver_wallet_id: @receiver_wallet.id, sender_wallet_id: @sender_wallet.id,
									amount: @amount, transaction_type: @transaction_type)

			if @transaction_type == "withdraw"
				@receiver_wallet.update!(INR: @receiver_wallet.INR - @amount)
			elsif @transaction_type == "deposit"
				@receiver_wallet.update!(INR: @receiver_wallet.INR + @amount)
			elsif @transaction_type == "transfer"
				@sender_wallet.update!(INR: @sender_wallet.INR - @amount)
				@receiver_wallet.update!(INR: @receiver_wallet.INR + @amount)
			end
			@receiver_wallet

		rescue 
			raise CustomError.new "Transacation cannot be processed" 
		end
	end

	private

		def user_authorized?(type, receiver_id)
			if type == "transfer"
				true
			elsif (type == "deposit" || type == "withdraw") && ( @sender.id != receiver_id )
				false
			else
				true
			end
		end  
end































