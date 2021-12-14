require 'eh_protobuf'

# EhProtobuf.config_client(
# 	EhProtobuf::Ats,
# 	host: "localhost",
# 	port: 50_050
# )
EhProtobuf.config_client(
	EhProtobuf::EmploymentHero,
	host: "localhost",
	port: 50_050
)
