class User < ApplicationRecord
	before_save :downcase_email
	has_one :wallet, dependent: :destroy
	after_create :make_wallet
	
	has_secure_password
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence:   true, length: { maximum: 255 },
	                format:     { with: VALID_EMAIL_REGEX },
	                uniqueness: { case_sensitive: false }


	def downcase_email
	  	self.email = self.email.delete(' ').downcase
	end

	def make_wallet
		self.create_wallet
	end
end
