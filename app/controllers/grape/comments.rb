module Grape
	class Comments < Grape::API
		format :json
		before do
			puts "Grape test here"

		end

		resources :comments do

			desc 'index'
			get do
				Comment.all
			end

			desc 'show'
			params do
				requires :id, type: Integer
			end
			get ":id" do
				Comment.where(id: params[:id]).first
			end

			desc 'create'
			params do
				requires :post_id, type: Integer
				requires :body, type: String
			end
			post do
				comment = Comment.new(post_id: params[:post_id], body: params[:body])
				begin
					comment.save!
					status 200
					comment
				rescue
					status 400
				end
			end

			desc 'update'
			params do
				requires :id, type: Integer
				requires :post_id, type: Integer
				requires :body, type: String
			end
			put do
				begin
					comment = Comment.find_by! id: params[:id]
					comment.update(params)
					comment
				rescue
					status 400
				end
			end

			desc 'destroy'
			params do
				requires :id, type: Integer
			end
			delete ":id" do
				begin
					comment = Comment.find_by! id: params[:id]
					comment.destroy
					status :no_content
				rescue
					status 404
				end
			end
		end


	end
end