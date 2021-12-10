
KafkaHandleEvent.register :member do
	topic 'User'

	primary_column :id, :id
	map_column :email, :email
	map_column :password, :password
	# map_column :email do |raw_message|
	# 	raw_message[:data][:user_email]
	# end
end