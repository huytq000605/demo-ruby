
require 'rails_helper'

RSpec.describe PostsController, type: :controller do
	token = Auth::Jwt.encode(email: "admin", role: "admin")
	describe 'Posts#index' do
		it 'return 200' do 
			request.headers["Authorization"] = "Bearer #{token}"
			get :index
			expect(response).to have_http_status(200)
		end
	end

	describe 'Posts#create' do
		it 'return 400' do
			request.headers["Authorization"] = "Bearer #{token}"
			post :create, params: {post: {title: "Test", body: ""}}
			get :show, params: {id: 1}
			expect(response).to have_http_status(404)
		end
	end

	describe 'Posts#show' do
		it 'return 404' do
			request.headers["Authorization"] = "Bearer #{token}"
			get :show, params: {id: 500}
			expect(response).to have_http_status(404)
		end
	end

	describe 'Posts#show' do
		it 'return 400' do
			request.headers["Authorization"] = "Bearer #{token}"
			get :show, params: {id: "abc"}
			expect(response).to have_http_status(400)
		end
	end

end
  