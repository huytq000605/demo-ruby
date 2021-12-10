class KafkaController < ApplicationController
  def produce
    UserResponder.call({email: "Test", password: "123456"})
    render json:{message: "Done"}
  end
end
