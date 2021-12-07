class PostsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		@posts = Post.includes(:comments).all
			
		render json: @posts.to_json(include: :comments)
	end

	def create 
		@post = Post.new(params_verify)
		if @post.save
			render json: @post
		else
			render json: {message: @post.errors.full_messages }
		end
	end

	def show
		@post = Post.find(id: params[:id])
		render json: @post
	end

	def update
		@post = Post.where(id: params[:id])
		if @post.update(params_verify)
			render json: @post
		else
			render json: {message: @post.errors.full_messages }
		end
	end

	def delete
		@post = Post.where(id: params[:id])
		if @post.destroy
			render json: {message: "Success"}
		else
			render json: {message: @post.errors.full_messages }
		end
	end

	private
		def params_verify
			params.require(:post).permit(:title, :body)
		end



end
