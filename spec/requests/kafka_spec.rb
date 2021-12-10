require 'rails_helper'

RSpec.describe "Kafkas", type: :request do
  describe "GET /produce" do
    it "returns http success" do
      get "/kafka/produce"
      expect(response).to have_http_status(:success)
    end
  end

end
