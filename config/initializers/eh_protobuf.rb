require 'eh_protobuf'

EhProtobuf.config_client(
	EhProtobuf::Ats,
	host: "localhost",
	port: 50_050
)