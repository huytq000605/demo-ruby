class UserResponder < ApplicationResponder
	topic :User, async: false

	def respond(data)
		respond_to :User, data
	end
end