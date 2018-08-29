class Wallet < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :INR, presence: true, numericality: true
  
end
