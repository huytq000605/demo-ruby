class KafkaController < ApplicationController
  def produce
    UserResponder.call({data: {email: "Test3", password: "123456", role: "admin"}, event: "create"})
    render json:{message: "Done"}
  end
end
