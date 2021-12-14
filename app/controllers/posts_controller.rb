class PostsController < ApplicationController
	before_action :need_have_id, only: [:show, :update, :destroy]

	def index
		# @posts = Post.includes(:comments).all
		# render json: @posts.to_json(include: :comments)
		@posts = Post.all
		render json: @posts
	end

	def create 
		if not is_member
			render json: {message: "Not member"} and return
		end
		@post = Post.new(params_verify)
		if @post.save
			render json: @post
			AutoPublishWorker.perform_in(1.minutes, @post.id)
		else
			invalid_argument(@post.errors.full_messages)
		end
	end

	def show
		@post = Post.find_by!(id: params[:id])
		authorize @post
		render json: @post
	end

	def update
		@post = Post.find_by!(id: params[:id])
		authorize @post
		if @post.update(params_verify)
			render json: @post
		else
			invalid_argument(@post.errors.full_messages)
		end
	end

	def destroy
		if Post.destroy(params[:id])
			render json: {message: "Success"}
		else
			invalid_argument(@post.errors.full_messages)
		end
	end

	private
		def params_verify
			params.require(:post).permit(:title, :body)
		end

		def need_have_id
			if params[:id].blank? or params[:id].nil? or params[:id].to_i <= 0
				respond_to do |format| 
					format.json {render json: {message: "No id provided"}, status: 400}
				end
			end
		end


end
