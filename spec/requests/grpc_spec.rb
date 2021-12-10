require 'rails_helper'

RSpec.describe "Grpcs", type: :request do
  describe "GET /call" do
    it "returns http success" do
      get "/grpc/call"
      expect(response).to have_http_status(:success)
    end
  end

end
