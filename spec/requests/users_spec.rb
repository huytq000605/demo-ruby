require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	token = Auth::Jwt.encode(email: "admin", role: "admin")

  describe "POST /login" do
    it "returns http success" do
			request.headers["Authorization"] = "Bearer #{token}"
      post :create, params: {user: {email: "admin", password: "123"}}
      post :login, params: {email: "admin", password: "123"}
      expect(response).to have_http_status(:success)
    end
  end

end
