require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'before publication' do  # (almost) plain English
    it 'cannot have comments' do   #
      expect { Post.create!.comments.create! }.to raise_error(ActiveRecord::RecordInvalid)  # test code
    end
  end
end

RSpec.describe PostsController, type: :controller do
  describe 'Posts#index' do
    it 'return 200' do 
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'Posts#create' do
    it 'return 400' do
      post :create, params: {post: {title: "Test", body: ""}}
      get :show, params: {id: 1}
      expect(response).to have_http_status(404)
    end
  end

  describe 'Posts#show' do
    it 'return 404' do
      get :show, params: {id: 500}
      expect(response).to have_http_status(404)
    end
  end

  describe 'Posts#show' do
    it 'return 400' do
      get :show, params: {id: "abc"}
      expect(response).to have_http_status(400)
    end
  end

    
  
end
