class GrpcController < ApplicationController
  def call
    message =  EhProtobuf::Ats::Client.test(organisation_id: "abc")
    render json: message
  end
end
