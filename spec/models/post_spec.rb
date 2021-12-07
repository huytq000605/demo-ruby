require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'before publication' do  # (almost) plain English
    it 'cannot have comments' do   #
      expect { Post.create!.comments.create! }.to raise_error(ActiveRecord::RecordInvalid)  # test code
    end
  end
end

RSpec.describe PostsController, type: :controller do
  describe 'PostIndex' do
    it 'return 200' do 
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
