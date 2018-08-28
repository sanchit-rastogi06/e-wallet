class JsonWebToken
	def self.encode(payload)
		payload.reverse_merge!(standard_claims)
		JWT.encode(payload, Rails.application.credentials.secret_key_base)
	end

	def self.decode(token)
		JWT.decode(token, Rails.application.credentials.secret_key_base)
	end

	def self.valid_payload(payload)
		if expired(payload) || payload[:iss] != standard_claims[:iss]
			false
		else
			true
		end
	end

	def self.standard_claims
		{ exp: 2.days.from_now.to_i, iss: 'koinex', }
	end

	def self.expired(payload)
		Time.at(payload[:exp]) < Time.now 
	end
end