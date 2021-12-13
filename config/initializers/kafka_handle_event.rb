
KafkaHandleEvent.register :user do
	topic 'User'

	primary_column :id, :id
	map_column :email, :email
	map_column :password, :password
	map_column :role, :role
	# map_column :email do |raw_message|
	# 	raw_message[:data][:user_email]
	# end
end

KafkaHandleEvent.register :member do
  topic 'EmploymentHero.Member'
  topic 'EmploymentHero.Member.AtsMigrate'

  primary_column :id, :uuid
  map_column :organisation_id, :organisation_uuid
  map_column :first_name, :first_name
  map_column :last_name, :last_name
  map_column :known_as, :known_as
  map_column :email, :email
  map_column :company_email, :original_company_email
  map_column :avatar_url, :avatar_url
  map_column :role, :role
  map_column :active, :original_active
end
