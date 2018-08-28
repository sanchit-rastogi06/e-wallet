class WalletTransaction < ApplicationRecord

  TRANSACTION_TYPES = ["withdraw", "deposit", "transfer"]
  validates :receiver_wallet_id, presence: true
  validates :sender_wallet_id, presence: true
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence:true, inclusion: { in: TRANSACTION_TYPES }
end
