class Mytopic < ApplicationConsumer
	def consume
		puts "------ TQHHHHHHHHHHHHHHHHHHHH ---------- Consume: #{params}}"
		debugger
	end
end