require 'jwt'

module Auth
	class Jwt
		KEY = 'mysecret' # ENV
		ALGORITHM = 'HS256' #ENV
		EXP = 60*60*5

		def self.encode(payload)
			exp = Time.now.to_i + EXP
			payload['exp'] = exp
			JWT.encode(payload, KEY, ALGORITHM)
		end

		def self.decode(token)
			begin
				JWT.decode token, KEY, true
			rescue
				nil
			end
		end
	end
end