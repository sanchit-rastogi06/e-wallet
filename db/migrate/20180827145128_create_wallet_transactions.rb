class CreateWalletTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_transactions do |t|
      t.decimal :amount, null: false
      t.string :transaction_type, null: false
      t.bigint :receiver_wallet_id, null: false
      t.bigint :sender_wallet_id, null: false

      t.timestamps
    end
  end
end
