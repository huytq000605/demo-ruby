class KafkaHandleEvents < ApplicationConsumer
	def consume
		message = params.payload
		message['topic_type'] = params.topic
		KafkaHandleEvent.handle_event(message)
	rescue => e
		puts e.message
	end
end
